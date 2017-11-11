import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args)
{
    version(Formoshlep)
    {
        import formoshlep;
        import vibe.http.server: HTTPServerSettings;

        auto settings = new HTTPServerSettings;
        settings.port = 8080;
        settings.bindAddresses = ["::1", "127.0.0.1"];

        (cast(FormoshlepPlatform) Platform.instance).httpServerSettings = settings;
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
    auto log_line_input = new EditLine("INPUT_1", "input log record here"d);
    hl1.addChild = log_line_input;
    hl1.addChild = new Button("BUTTON_SUBMIT_0", "BUTTON_RESOURCE_ID_0");

    hl2.addChild = new Button("BUTTON_SUBMIT_1", "BUTTON_RESOURCE_ID_1");
    hl2.addChild = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    hl2.addChild = new EditLine("INPUT_2", "initial text 2"d);
    hl2.addChild = new Button("BUTTON_SUBMIT_2", "BUTTON_RESOURCE_ID_2");

    auto log_text = new TextWidget("SOME_TEXT", "This is text too"d);

    auto btn0 = new Button("SOME_BUTTON_0", "Press for add log line");
    btn0.click =
        delegate(Widget w)
        {
            log_text.text = log_text.text ~ log_line_input.text ~ ' ';
            return true;
        };

    vl3.addChild = btn0;
    vl3.addChild = new Button("SOME_BUTTON_1", "Some button 1");
    window.mainWidget.addChild = log_text;

    // test of custom method implementation
    {
        alias Callback = void delegate(Widget);

        // dry run custom method (callback isn't installed)
        log_text.customMethod!("test") = Widget.CustomMethodArgs!Callback(log_text);

        // set new custom method callback
        log_text.customMethod!("test") = Widget.CustomMethodArgs!Callback
        (
            (Widget w)
            {
                w.text = "asdf"d;
            }
        );

        // run custom method for some widget
        log_text.customMethod!("test") = Widget.CustomMethodArgs!Callback(log_text);

        assert(log_text.text == "asdf"d);
        assert(btn0.text != "asdf"d);
    }

    window.show();

    return Platform.instance.enterMessageLoop();
}
