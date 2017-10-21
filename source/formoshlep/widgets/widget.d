module formoshlep.widgets.widget;

import formoshlep: HtmlDocPiece;

interface WebWidget
{
    //~ package:
    HtmlDocPiece toHtml() const;
}

import dhtags;
static import dlangui.widgets.controls;

class TextWidget : dlangui.widgets.controls.TextWidget, WebWidget
{
    this(T = string)(string ID = null, T text = null)
    {
        super(ID, text);
    }

    HtmlDocPiece toHtml() const
    {
        //TODO: dlangui's TextWidget.test() should be a const and used here

        import std.conv: to;

        return HtmlDocPiece([_text.to!string]);
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
