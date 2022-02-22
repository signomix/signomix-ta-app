package com.signomix.app.auth;

import java.net.URI;
import java.net.URISyntaxException;

import javax.inject.Singleton;
import javax.ws.rs.ProcessingException;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.ext.Provider;

import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.rest.client.RestClientBuilder;
import org.jboss.logging.Logger;

import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;

@Provider
@Singleton
public class SecurityFilter implements ContainerRequestFilter {

    private static final Logger LOG = Logger.getLogger(SecurityFilter.class);

    private static final String SIGNOMIX_TOKEN_NAME = "signomixToken";

    @Context
    UriInfo info;

    @Context
    HttpServerResponse response;
    @Context
    HttpServerRequest request;

    @ConfigProperty(name = "signomix.app.key", defaultValue = "not_configured")
    String appKey;
    @ConfigProperty(name = "signomix.auth.host", defaultValue = "not_configured")
    String authHost;

    @Override
    public void filter(ContainerRequestContext context) {

        final String method = context.getMethod();
        final String path = info.getPath();
        final String address = request.remoteAddress().toString();

        String token = request.getParam("tid", "");
        //String token=(String)context.getProperty("tid");
        LOG.infof("App key: %s", appKey);
        LOG.infof("Auth host: %s", authHost);
        // LOG.infof("Request %s %s from IP %s", method, path, address);
        if (null != token && !token.isEmpty()) {
            if (token.endsWith("/")) {
                token = token.substring(0, token.length() - 1);
            }
        }
        if (null == token || token.isEmpty()) {
            Cookie cookie=request.getCookie(SIGNOMIX_TOKEN_NAME);
            token = cookie!=null?cookie.getValue():"";
            LOG.info("token from cookie");
        }
        LOG.infof("Token value: %s", token);
        if (null != token && !token.isEmpty()) {
            SessionParams sessionParams = getUserParams(token);
            if (null != sessionParams) {
                context.getHeaders().add("X-user-token", token);
                response.headers().add("X-user-id", sessionParams.user);
                context.getHeaders().add("X-user-id", sessionParams.user);
                if ("public".equalsIgnoreCase(sessionParams.user)) {
                    response.headers().add("X-issuer-id", sessionParams.issuer);
                    context.getHeaders().add("X-issuer-id", sessionParams.issuer);
                } else {
                    response.headers().add("X-user-role", sessionParams.role);
                    context.getHeaders().add("X-user-role", sessionParams.role);
                }
            }
        }
    }

    private SessionParams getUserParams(String token) {
        AuthClient client;
        SessionParams result = null;
        try {
            client = RestClientBuilder.newBuilder()
                    .baseUri(new URI(authHost))
                    .followRedirects(true)
                    .build(AuthClient.class);
            result = client.checkToken(token, appKey, "true");
        } catch (URISyntaxException ex) {
            LOG.error(ex.getMessage());
            // TODO: notyfikacja użytkownika o błędzie
        } catch (ProcessingException ex) {
            LOG.error(ex.getMessage());
        } catch (WebApplicationException ex) {
            LOG.error(ex.getMessage());
        } catch (Exception ex) {
            LOG.error(ex.getMessage());
            // TODO: notyfikacja użytkownika o błędzie
        }
        return result;
    }

}
