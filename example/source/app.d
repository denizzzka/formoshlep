import vibe.http.server;
import dlangui;

mixin APP_ENTRY_POINT;

Window window;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args)
{
    import formoshlep;

    window = Platform.instance.createWindow("My Window", null);

    window.mainWidget = new VerticalLayout();
    Widget w = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    Widget inputBox = new InputBox(UIString.fromId("INPUT_CAPTION"c), UIString.fromId("INPUT_MSG"c), /*parentWindow*/ null, "initial text"d, /*handler*/ null);
    Widget submitButton = new Button("BUTTON_SUBMIT", "BUTTON_RESOURCE_ID");

    window.mainWidget.addChild(w);
    window.mainWidget.addChild(inputBox);
    window.mainWidget.addChild(submitButton);

    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];
    settings.sessionStore = new MemorySessionStore;

    listenHTTP(settings, &handleRequest);

    import vibe.core.core;

    runApplication();

    return 0;
}

void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    import formoshlep;

    // set Platform.instance
    {
        enum sess_id = "sess_id";

        if (req.session)
        {
            // FIXME: fails after 2 attempt:
            //~ Platform.setInstance = req.session.get!size_t(sess_id).getPlatformBySerial;
        }
        else
        {
            //~ Platform.setInstance = new FormoshlepPlatform();

            //~ auto s = res.startSession();
            //~ s.set(sess_id, cast(size_t) (cast(FormoshlepPlatform) Platform.instance).serial);
        }
    }

    if (req.path != "/")
        res.writeBody("Unknown path");
    else
    {
        window.mainWidget.readWidgetsState(req);
        window.mainWidget.processEvents(req);

        (cast(FormoshlepPlatform) Platform.instance).genHttpServerResponse(res);
    }

    //~ Platform.instance.enterMessageLoop();

    window.show();
}
