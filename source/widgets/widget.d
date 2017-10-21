module formoshlep.widgets.widget;

import formoshlep;

interface WebWidget
{
    HtmlDocPiece toHtml() const;
}

import dhtags;
import ctrls = dlangui.widgets.controls;

class TextWidget : ctrls.TextWidget, WebWidget
{
    HtmlDocPiece toHtml() const
    {
	//TODO: dlangui's TextWidget.test() should be a const and used here

	import std.conv: to;

	return HtmlDocPiece([_text.to!string]);
    }
}
