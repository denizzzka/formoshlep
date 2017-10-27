module formoshlep.widgets.widget;

import formoshlep: HtmlDocPiece;
import vibe.http.server: HTTPServerRequest;

interface WebWidget
{
    //TODO: enable it:
    //~ package:
    HtmlDocPiece toHtml() const;
    void readState(HTTPServerRequest req);
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

    void readState(in HTTPServerRequest req) {}
}

static import dlangui.dialogs.inputbox;

class InputBox : dlangui.dialogs.inputbox.InputBox, WebWidget
{
    import dlangui.core.i18n: UIString;
    import dlangui: Window;
    import std.conv: to;

    this(UIString caption, UIString message, Window parentWindow, dstring initialText, void delegate(dstring result) handler)
    {
        super(caption, message, parentWindow, initialText, handler);
    }

    HtmlDocPiece toHtml() const
    {
        import dhtags;

        //TODO: dlangui's TextWidget.text() should be a const and used here
        return HtmlDocPiece([
                input(value=_text.to!string).toString
            ]);
    }

    void readState(HTTPServerRequest req)
    {
        _text = req.form.get(id).to!dstring;
    }
}

static import dlangui.widgets.layouts;

class VerticalLayout : dlangui.widgets.layouts.VerticalLayout, WebWidget
{
    HtmlDocPiece toHtml() const
    {
        import std.conv: to;
        import formoshlep: toString;

        HtmlDocPiece ret = ["<!-- VerticalLayout -->"];

        for(auto i = 0; i < childCount; i++)
            ret.insertFront((cast(WebWidget) child(i)).toHtml.toString);

        return ret;
    }

    void readState(in HTTPServerRequest req) {}
}
