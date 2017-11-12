module formoshlep.widget;

import dht = dhtags;
import attrs = dhtags.attrs;
import dhtags.tags.tag: HtmlFragment, HtmlString;
import vibe.http.server: HTTPServerRequest;
import std.conv: to;
import openmethods;
mixin(registerMethods);

import dlangui.widgets.widget: Widget;
import dlangui.widgets.controls: TextWidget, Button;
import dlangui.widgets.editors: EditLine;
import dlangui.widgets.layouts: LinearLayout, Orientation;

import dlangui.core.events;

package struct FormoEvent
{
    KeyEvent keyEvent;
    MouseEvent mouseEvent;
}

void readState(virtual!Widget, virtual!HTTPServerRequest);
FormoEvent[] getEvents(virtual!Widget, virtual!(const HTTPServerRequest));
HtmlFragment toHtml(virtual!(const Widget));

// Custom Widget methods:
@method void _readState(Widget w, HTTPServerRequest req) {}
@method HtmlFragment _toHtml(in Widget w) { assert(false, "HTML output isn't implemented"); }
@method FormoEvent[] _getEvents(Widget w, HTTPServerRequest req) { return null; }

// TextWidget:
@method HtmlFragment _toHtml(in TextWidget w)
{
    return new HtmlString(w.text.to!string);
}

// EditLine:
@method void _readState(EditLine w, HTTPServerRequest req)
{
    if(req.form.get(w.id, "IMPOSSIBLE_VALUE") != "IMPOSSIBLE_VALUE") //FIXME: remove that shit
        w.text = req.form.get(w.id).to!dstring;
}
@method FormoEvent[] _getEvents(EditLine w, HTTPServerRequest req)
{
    import std.exception: enforce;

    enforce(w.action is null);

    return null;
}
@method HtmlFragment _toHtml(in EditLine w)
{
    return dht.input(attrs.type="text", attrs.name=w.id, attrs.value=w.text.to!string);
}

// Button:
@method HtmlFragment _toHtml(in Button w)
{
    return dht.input(dht.type="submit", dht.name=w.id, dht.value=w.text.to!string);
}
@method FormoEvent[] _getEvents(Button w, HTTPServerRequest req)
{
    if(req.form.get(w.id) is null)
        return null;
    else
        return
        [
            FormoEvent(null, new MouseEvent(MouseAction.ButtonDown, MouseButton.Left, 0, -10, -10, 0)),
            FormoEvent(null, new MouseEvent(MouseAction.ButtonUp,   MouseButton.Left, 0, -10, -10, 0))
        ];
}

// LinearLayout:
@method HtmlFragment _toHtml(in LinearLayout w)
{
    // TODO: make dlangui's orintation() const
    auto orientation = (cast(LinearLayout) w).orientation();
    final switch(orientation)
    {
        case Orientation.Horizontal:
            string ret;

            for(auto i = 0; i < w.childCount; i++)
                ret ~= w.child(i).toHtml.toString(false);

            return dht.div(attrs.style="width: auto; float: left")(ret);

        case Orientation.Vertical:
            string ret;

            for(auto i = 0; i < w.childCount; i++)
                ret ~=
                    dht.div(attrs.style="clear: both")
                    (
                        w.child(i).toHtml
                    ).toString(false);

            return dht.div(attrs.style="float: left")(ret);
    }
}

static this()
{
    updateMethods();
}

void readWidgetsState(Widget w, HTTPServerRequest req)
{
    w.readState(req);

    for(auto i = 0; i < w.childCount; i++)
        w.child(i).readWidgetsState(req);
}

void processEvents(Widget w, HTTPServerRequest req)
{
    FormoEvent[] events = w.getEvents(req);

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
