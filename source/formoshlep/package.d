module formoshlep;

public import formoshlep.platform;
public import formoshlep.widget;
public import dlangui.widgets.widget: Widget;

import std.container : SList;

alias HtmlDocPiece = SList!string;

string toString(HtmlDocPiece a) @property
{
    string ret;

    foreach(s; a)
        ret = s ~ ret;

    return ret;
}
