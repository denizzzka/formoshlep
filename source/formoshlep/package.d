module formoshlep;

public import formoshlep.platform;
public import formoshlep.widgets.widget;
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

import vibe.http.server: HTTPServerRequest;

void readWidgetsState(Widget w, HTTPServerRequest req)
{
    for(auto i = 0; i < w.childCount; i++)
    {
        (cast(WebWidget) w).readState(req);

        w.child(i).readWidgetsState(req);
    }
}
