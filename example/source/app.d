import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args)
{
    version(Formoshlep)
    {
        import formoshlep;
    }

    Window window = Platform.instance.createWindow("My Window", null);

    window.mainWidget = new VerticalLayout();
    auto vl1 = new HorizontalLayout();
    auto vl2 = new HorizontalLayout();
    auto vl3 = new HorizontalLayout();
    window.mainWidget.addChild = vl1;
    window.mainWidget.addChild = vl2;
    window.mainWidget.addChild = vl3;
    auto hl1 = new VerticalLayout();
    auto hl2 = new VerticalLayout();
    vl2.addChild = hl1;
    vl2.addChild = hl2;

    vl1.addChild = new TextWidget("SOME_TEXT", "Upper text 1"d);
    vl1.addChild = new TextWidget("SOME_TEXT", "Upper text 2"d);
    vl1.addChild = new TextWidget("SOME_TEXT", "Upper text 3"d);
    vl1.addChild = new TextWidget("SOME_TEXT", "Upper text 4"d);
    vl1.addChild = new TextWidget("SOME_TEXT", "Upper text 5"d);
    vl1.addChild = new TextWidget("SOME_TEXT", "Upper text 6"d);

    hl1.addChild = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    hl1.addChild = new EditLine("INPUT_1", "initial text 1"d);
    hl1.addChild = new Button("BUTTON_SUBMIT_0", "BUTTON_RESOURCE_ID_0");

    hl2.addChild = new Button("BUTTON_SUBMIT_1", "BUTTON_RESOURCE_ID_1");
    hl2.addChild = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    hl2.addChild = new EditLine("INPUT_2", "initial text 2"d);
    hl2.addChild = new Button("BUTTON_SUBMIT_2", "BUTTON_RESOURCE_ID_2");

    vl3.addChild = new Button("SOME_BUTTON_0", "Some button 0");
    vl3.addChild = new TextWidget("SOME_TEXT", "This is text too"d);
    vl3.addChild = new Button("SOME_BUTTON_1", "Some button 1");

    version(Formoshlep)
    {
        import vibe.http.server: HTTPServerSettings;
        auto settings = new HTTPServerSettings;
        settings.port = 8080;
        settings.bindAddresses = ["::1", "127.0.0.1"];

        (cast(FormoshlepPlatform) Platform.instance).httpServerSettings = settings;
    }

    window.show();

    return Platform.instance.enterMessageLoop();
}
