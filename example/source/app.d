import vibe.http.server;

void main()
{
    listenHTTP(":8080", &handleRequest);

    import vibe.core.core;

    runApplication();
}

void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    import formoshlep;

    auto mainWidget = new VerticalLayout();
    Widget w = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    mainWidget.addChild(w);

    if (req.path == "/")
        res.writeBody((cast(WebWidget) w).toHtml().empty ? "true" : "false");
}
