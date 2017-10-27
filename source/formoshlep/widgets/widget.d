module formoshlep.widgets.widget;

import formoshlep: HtmlDocPiece;
import vibe.http.server: HTTPServerRequest;
import std.exception: enforce;
import std.conv: to;
import dhtags;

static import dlangui.widgets.controls;
static import dlangui.dialogs.inputbox;
static import dlangui.widgets.layouts;

import dlangui.core.i18n: UIString;
import dlangui: Window;

interface WebWidget
{
    //TODO: enable it:
    //~ package:
    HtmlDocPiece toHtml() const;
    void readState(HTTPServerRequest req);
}

class TextWidget : dlangui.widgets.controls.TextWidget, WebWidget
{
    this(T = string)(string ID = null, T text = null)
    {
        super(ID, text);
    }

    HtmlDocPiece toHtml() const
    {
        import std.conv: to;

        //TODO: dlangui's TextWidget.text() should be a const and used here
        return HtmlDocPiece([
                h2(_text.to!string).toString //TODO: replace h2 to more suitable tag
            ]);
    }

    void readState(in HTTPServerRequest req) {}
}

class InputBox : dlangui.dialogs.inputbox.InputBox, WebWidget
{
    this(UIString caption, UIString message, Window parentWindow, dstring initialText, void delegate(dstring result) handler)
    {
        enforce(handler == null);
        super(caption, message, parentWindow, initialText, handler);
    }

    HtmlDocPiece toHtml() const
    {
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

class Button : dlangui.widgets.controls.Button, WebWidget
{
    this(string ID, string labelResourceId)
    {
        super(ID, labelResourceId);
    }

    HtmlDocPiece toHtml() const
    {
        return HtmlDocPiece([
                input(type="submit", name=id, value=text.to!string).toString
            ]);
    }

    void readState(in HTTPServerRequest req) {}
}

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
