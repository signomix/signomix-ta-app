package com.signomix.app.auth;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.ProcessingException;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.WebApplicationException;

import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@RegisterRestClient
@Path("/api/auth")
public interface AuthClient {

    @GET
    @Produces("application/json")
    SessionParams checkToken(@QueryParam("tid") String token, @QueryParam("appkey") String appKey, @QueryParam("data") String data) throws ProcessingException, WebApplicationException;

}
