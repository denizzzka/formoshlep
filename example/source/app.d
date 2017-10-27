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

    //~ Window window = Platform.instance.createWindow("My Window", null);
    Widget mainWidget = new VerticalLayout();
    Widget w = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    Widget inputBox = new InputBox(UIString.fromId("INPUT_CAPTION"c), UIString.fromId("INPUT_MSG"c), /*parentWindow*/ null, "initial text"d, /*handler*/ null);

    mainWidget.addChild(w);
    mainWidget.addChild(inputBox);

    if (req.path == "/")
    {
        mainWidget.readWidgetsState(req);

        res.writeBody((cast(WebWidget) mainWidget).toHtml.toString, "text/html; charset=UTF-8");
    }
    else
        res.writeBody("Unknown path");

    //~ window.show();

    if(!req.form.empty)
        Platform.instance.enterMessageLoop();
}
