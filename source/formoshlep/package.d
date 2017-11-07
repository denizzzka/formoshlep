module formoshlep;

public import formoshlep.platform;
public import formoshlep.widget;
public import dlangui.widgets.widget: Widget;

import dhtags.tags.tag: HtmlFragment;
alias HtmlDocPiece = HtmlFragment;

import vibe.http.server: HTTPServerRequest;

void readWidgetsState(Widget w, HTTPServerRequest req)
{
    (cast(WebWidget) w).readState(req);

    for(auto i = 0; i < w.childCount; i++)
        w.child(i).readWidgetsState(req);
}

void processEvents(Widget w, HTTPServerRequest req)
{
    FormoEvent[] events = (cast(WebWidget) w).getEvents(req);

    foreach(e; events)
    {
        if(e.keyEvent !is null)
            w.onKeyEvent(e.keyEvent);

        if(e.mouseEvent !is null)
            w.onMouseEvent(e.mouseEvent);
    }

    for(auto i = 0; i < w.childCount; i++)
        w.child(i).processEvents(req);
}
