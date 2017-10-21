import vibe.http.server;

void main()
{
    listenHTTP(":8080", &handleRequest);

    import vibe.core.core;

    runApplication();
}

void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    if (req.path == "/")
        res.writeBody("Hello, World!");
}
