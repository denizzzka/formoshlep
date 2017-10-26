module formoshlep;

public import formoshlep.widgets.widget;
public import dlangui.widgets.widget: Widget;

import std.container : SList;

alias HtmlDocPiece = SList!string;

string toHtmlString(HtmlDocPiece a)
{
    string ret;

    foreach(s; a)
        ret ~= s;

    return ret;
}
