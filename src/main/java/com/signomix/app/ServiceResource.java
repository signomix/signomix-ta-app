package com.signomix.app;

import java.util.List;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.event.Observes;
import javax.inject.Inject;
import javax.ws.rs.BadRequestException;
import javax.ws.rs.GET;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.jboss.logging.Logger;

import com.signomix.app.auth.SessionParams;
import com.signomix.common.Token;
import com.signomix.common.db.AuthDaoIface;

import io.agroal.api.AgroalDataSource;
import io.quarkus.agroal.DataSource;
import io.quarkus.runtime.StartupEvent;
import io.vertx.mutiny.core.Vertx;

@ApplicationScoped
@Path("/")
public class ServiceResource {
    private static final Logger LOG = Logger.getLogger(ServiceResource.class);

    // TODO: move to config
    private long sessionTokenLifetime = 30; // minutes
    private long permanentTokenLifetime = 10 * 365 * 24 * 60; // 10 years in minutes

    private final Vertx vertx;

    @ConfigProperty(name = "signomix.statuspage.url", defaultValue = "")
    String statusPageUrl;

    @ConfigProperty(name = "signomix.release", defaultValue = "")
    String releaseNumber;

    @ConfigProperty(name = "signomix.google.tracking.id", defaultValue = "")
    String trackingId;

    @Inject
    @DataSource("auth")
    AgroalDataSource tsDs;
    AuthDaoIface authDao = null;

    @Inject
    public ServiceResource(Vertx vertx) {
        this.vertx = vertx;
    }

    public void onApplicationStart(@Observes StartupEvent event) {
        authDao = new com.signomix.common.tsdb.AuthDao();
        authDao.setDatasource(tsDs);

    }

    public SessionParams checkToken(String token) {
        Token tokenObj = authDao.getToken(token, sessionTokenLifetime, permanentTokenLifetime);
        SessionParams sessionParams = new SessionParams();
        sessionParams.setToken(token);
        sessionParams.setUser(tokenObj.getUid());
        sessionParams.setIssuer(tokenObj.getIssuer());
        sessionParams.setRole("");
        return sessionParams;
    }

    private String updateContent(HttpHeaders headers, String tokenId, String content) {
        String fileContent = content;
        List<String> headerValues;
        String userId = "";
        String issuerId = "";
        String token = "";
        String roles = "";
        if (tokenId != null && !tokenId.isEmpty()) {
            token = tokenId;
            if(token.endsWith("/")) {
                token = token.substring(0,token.length()-1);
            }
        } else {
            headerValues = headers.getRequestHeader("X-user-id");
            if (headerValues.size() > 0) {
                userId = headerValues.get(0);
                LOG.info("X-user-id: " + userId);
            }
            headerValues = headers.getRequestHeader("X-user-role");
            if (headerValues.size() > 0) {
                roles = headerValues.get(0);
                LOG.info("X-user-role: " + roles);
            }
            headerValues = headers.getRequestHeader("X-issuer-id");
            if (headerValues.size() > 0) {
                issuerId = headerValues.get(0);
                LOG.info("X-issuer-id: " + issuerId);
            }
            headerValues = headers.getRequestHeader("X-user-token");
            if (headerValues.size() > 0) {
                token = headerValues.get(0);
                LOG.info("X-user-token: " + token);
            }
        }

        fileContent = fileContent.replaceAll("\\$token", token);
        fileContent = fileContent.replaceAll("\\$user", userId);
        fileContent = fileContent.replaceAll("\\$gaTrackingID", trackingId);
        String[] tmpRole = roles.split(",");
        String roles4Arr = "";
        for (int i = 0; i < tmpRole.length; i++) {
            roles4Arr = roles4Arr + "\"" + tmpRole[i] + "\"";
            if (i < tmpRole.length - 1)
                roles4Arr = roles4Arr + ",";
        }
        fileContent = fileContent.replaceAll("\\$roles", roles4Arr);
        return fileContent;
    }

    @GET
    @Path("/app/")
    @Produces(MediaType.TEXT_HTML)
    public String readindexFile(@Context HttpHeaders headers, @QueryParam("tid") String token) {
        String fileContent;
        try {
            fileContent = vertx.fileSystem().readFileBlocking("app/index.html").toString();
            fileContent = updateContent(headers, token, fileContent);
        } catch (Exception ex) {
            throw new NotFoundException("Not found: index.html");
        }
        return fileContent;
    }

    @GET
    @Path("/app/{file}")
    @Produces(MediaType.TEXT_HTML)
    public String readShortFile(@Context HttpHeaders headers, @PathParam("file") String fileName,
            @QueryParam("tid") String token) {
        String fileContent;
        try {
            fileContent = vertx.fileSystem().readFileBlocking("app/" + fileName).toString();
            if ("embed.html".equalsIgnoreCase(fileName)) {
                fileContent = updateContent(headers, token, fileContent);
            }
        } catch (Exception ex) {
            throw new NotFoundException("Not found: " + fileName);
        }
        return fileContent;
    }

    @GET
    @Path("/api/app/health")
    @Produces(MediaType.TEXT_PLAIN)
    public String getHealthStatus() {
        return "OK";
    }

    @GET
    @Path("/api/app/config")
    @Produces(MediaType.TEXT_PLAIN)
    public String getConfigParam(@QueryParam("param") String paramName) {
        if (null == paramName) {
            throw new BadRequestException("null param");
        }
        switch (paramName.toLowerCase()) {
            case "java_version":
                return System.getProperty("java.version");
            case "statuspage_url":
                return statusPageUrl;
            case "release":
                return releaseNumber;
            default:
                throw new BadRequestException();
        }
    }

}