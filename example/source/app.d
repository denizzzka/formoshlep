import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args)
{
    import formoshlep;

    Window window = Platform.instance.createWindow("My Window", null);

    window.mainWidget = new VerticalLayout();
    auto hl1 = new HorizontalLayout();
    auto hl2 = new HorizontalLayout();
    window.mainWidget.addChild = hl1;
    window.mainWidget.addChild = hl2;

    hl1.addChild = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    hl1.addChild = new InputBox(UIString.fromId("INPUT_CAPTION"c), UIString.fromId("INPUT_MSG"c), /*parentWindow*/ null, "initial text"d, /*handler*/ null);
    //~ hl1.addChild = new Button("BUTTON_SUBMIT", "BUTTON_RESOURCE_ID");

    hl2.addChild = new Button("BUTTON_SUBMIT_1", "BUTTON_RESOURCE_ID_1");
    hl2.addChild = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    //~ hl2.addChild = new InputBox(UIString.fromId("INPUT_CAPTION"c), UIString.fromId("INPUT_MSG"c), /*parentWindow*/ null, "initial text"d, /*handler*/ null);
    //~ hl2.addChild = new Button("BUTTON_SUBMIT_2", "BUTTON_RESOURCE_ID_2");

    import vibe.http.server: HTTPServerSettings;
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];

    (cast(FormoshlepPlatform) Platform.instance).httpServerSettings = settings;

    window.show();

    return Platform.instance.enterMessageLoop();
}
