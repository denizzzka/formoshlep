import vibe.http.server;
import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args)
{
    listenHTTP(":8080", &handleRequest);

    import vibe.core.core;

    runApplication();

    return 0;
}

void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    import formoshlep;

    auto mainWidget = new VerticalLayout();
    Widget w = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    mainWidget.addChild(w);

    if (req.path == "/")
        res.writeBody((cast(WebWidget) w).toHtml().empty ? "true" : "false");

    //~ window.show();

    if(!req.form.empty)
        Platform.instance.enterMessageLoop();
}
