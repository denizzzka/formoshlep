import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args)
{
    import formoshlep;

    Window window = Platform.instance.createWindow("My Window", null);

    window.mainWidget = new VerticalLayout();
    Widget w = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    Widget inputBox = new InputBox(UIString.fromId("INPUT_CAPTION"c), UIString.fromId("INPUT_MSG"c), /*parentWindow*/ null, "initial text"d, /*handler*/ null);
    Widget submitButton = new Button("BUTTON_SUBMIT", "BUTTON_RESOURCE_ID");

    window.mainWidget.addChild(w);
    window.mainWidget.addChild(inputBox);
    window.mainWidget.addChild(submitButton);

    import vibe.http.server: HTTPServerSettings;
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];

    (cast(FormoshlepPlatform) Platform.instance).httpServerSettings = settings;

    window.show();

    return Platform.instance.enterMessageLoop();
}
