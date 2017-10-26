module formoshlep.widgets.widget;

import formoshlep: HtmlDocPiece;

interface WebWidget
{
    //~ package:
    HtmlDocPiece toHtml() const;
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
                h2(_text.to!string).toString
            ]);
    }
}

static import dlangui.widgets.layouts;

class VerticalLayout : dlangui.widgets.layouts.VerticalLayout, WebWidget
{
    HtmlDocPiece toHtml() const
    {
        return HtmlDocPiece();
    }
}
