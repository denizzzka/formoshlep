module formoshlep.widgets.widget;

import formoshlep: HtmlDocPiece;

interface WebWidget
{
    //~ package:
    HtmlDocPiece toHtml();
}

static import dlangui.widgets.controls;

class TextWidget : dlangui.widgets.controls.TextWidget, WebWidget
{
    this(T = string)(string ID = null, T text = null)
    {
        super(ID, text);
    }

    HtmlDocPiece toHtml() const
    {
        import dhtags;
        import std.conv: to;

        //TODO: dlangui's TextWidget.text() should be a const and used here
        return HtmlDocPiece([
                h2(_text.to!string).toString //TODO: replace h2 to more suitable tag
            ]);
    }
}

static import dlangui.dialogs.inputbox;

class InputBox : dlangui.dialogs.inputbox.InputBox, WebWidget
{
    import dlangui.core.i18n: UIString;
    import dlangui: Window;

    this(UIString caption, UIString message, Window parentWindow, dstring initialText, void delegate(dstring result) handler)
    {
        super(caption, message, parentWindow, initialText, handler);
    }

    HtmlDocPiece toHtml() const
    {
        import dhtags;
        import std.conv: to;

        //TODO: dlangui's TextWidget.text() should be a const and used here
        return HtmlDocPiece([
                input(value=_text.to!string).toString
            ]);
    }
}

static import dlangui.widgets.layouts;

class VerticalLayout : dlangui.widgets.layouts.VerticalLayout, WebWidget
{
    HtmlDocPiece toHtml()
    {
        import std.conv: to;
        import formoshlep: toString;

        HtmlDocPiece ret = ["<!-- VerticalLayout -->"];

        for(auto i = 0; i < childCount; i++)
            ret.insertFront((cast(WebWidget) child(i)).toHtml.toString);

        return ret;
    }
}
