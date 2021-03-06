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

    vl1.addChild = new TextWidget("SOME_TEXT1", "Upper text 1"d);
    vl1.addChild = new TextWidget("SOME_TEXT2", "Upper text 2"d);
    vl1.addChild = new TextWidget("SOME_TEXT3", "Upper text 3"d);
    vl1.addChild = new TextWidget("SOME_TEXT4", "Upper text 4"d);
    vl1.addChild = new TextWidget("SOME_TEXT5", "Upper text 5"d);
    vl1.addChild = new TextWidget("SOME_TEXT6", "Upper text 6"d);

    vl1.child(0).textColor("red").fontSize(20).fontWeight(800).fontFace("Arial");

    hl1.addChild = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    auto log_line_input = new EditLine("INPUT_1", "input log record here"d);
    hl1.addChild = log_line_input;
    hl1.addChild = new Button("BUTTON_SUBMIT_8", "BUTTON_RESOURCE_ID_8");
    hl1.addChild = (new ImageTextButton("BUTTON_SUBMIT_disabled", "dlangui-logo1", "BUTTON_DISABLED")).enabled(false);
    hl1.addChild = new ImageTextButton("BUTTON_SUBMIT_0", "dlangui-logo1", "BUTTON_RESOURCE_ID_0");
    hl1.childById("BUTTON_SUBMIT_0").textColor("green").fontSize(16).fontWeight(800).fontFace("Courier");
    hl1.addChild = new CheckBox("CHECK_BOX_0", "Some check box");
    hl1.addChild = new CheckBox("CHECK_BOX_1", "Some disabled check box").enabled(false);

    hl2.addChild = new Button("BUTTON_SUBMIT_1", "BUTTON_RESOURCE_ID_1");
    hl2.addChild = new TextWidget("HELLO_WORLD", "Hello, World!"d);
    hl2.addChild = (new EditLine("INPUT_2", "initial text 2"d)).enabled(false);
    hl2.addChild = new Button("BUTTON_SUBMIT_2", "BUTTON_RESOURCE_ID_2");
    hl2.addChild = new ComboBox("combo0", ["value 1"d, "value 2"d, "value 3"d]);
    hl2.addChild = (new ComboBox("combo1", ["value 1"d, "value 2"d, "value 3"d])).selectedItemIndex(1);

    auto log_text = new TextWidget("SOME_TEXT", "This is text too"d);
    auto btn0 = new Button("SOME_BUTTON_0", "Press for add log line");
    btn0.click =
        delegate(Widget w)
        {
            log_text.text = log_text.text ~ log_line_input.text ~ ' ';
            return true;
        };
    hl1.childById("BUTTON_SUBMIT_0").click =
        delegate(Widget w)
        {
            log_text.text = log_text.text ~ "image button pressed" ~ ' ';
            return true;
        };

    vl3.addChild = btn0;
    vl3.addChild = (new Button("SOME_BUTTON_1", "Some button 1")).enabled(false);

    window.mainWidget.addChild = log_text;
    vl3.addChild = new ImageWidget("Computer", "computer");
    auto rbts = new GroupBox("radiobuttons", "RadioButton"d);
    rbts.addChild = new RadioButton("rb1", "RadioButton 1"d).checked(true);
    rbts.addChild(new RadioButton("rb2", "RadioButton 2"d));
    rbts.addChild(new RadioButton("rb3", "RadioButton disabled"d).enabled(false));
    hl1.addChild = rbts;

    window.show();

    return Platform.instance.enterMessageLoop();
}
