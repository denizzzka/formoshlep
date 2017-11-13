module formoshlep.widget;

import tags = dhtags.tags;
import attrs = dhtags.attrs;
import dhtags.tags.tag: HtmlFragment, HtmlString;
import vibe.http.server: HTTPServerRequest;
import std.conv: to;
import dlangui.core.events;
import openmethods;
mixin(registerMethods);

package:

struct FormoEvent
{
    KeyEvent keyEvent;
    MouseEvent mouseEvent;
}

// Custom Widget methods:
void readState(virtual!Widget, HTTPServerRequest);
FormoEvent[] getEvents(virtual!Widget, HTTPServerRequest);
HtmlFragment toHtml(virtual!Widget);

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

public:

// Custom methods implementation:
import dlangui.widgets.widget: Widget;
@method void _readState(Widget w, HTTPServerRequest req) {}
@method FormoEvent[] _getEvents(Widget w, HTTPServerRequest req) { return null; }
@method HtmlFragment _toHtml(Widget w) { assert(false, "HTML output isn't implemented"); }

import dlangui.widgets.controls: TextWidget;
@method HtmlFragment _toHtml(TextWidget w)
{
    return tags.span(w.text.to!string).addStyle(w);
}

import dlangui.widgets.editors: EditLine;
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
@method HtmlFragment _toHtml(EditLine w)
{
    return tags.input(attrs.type="text", attrs.name=w.id, attrs.value=w.text.to!string, attrs.style=w.styleStr);
}

import dlangui.widgets.controls: Button;
@method HtmlFragment _toHtml(Button w)
{
    return tags.input(attrs.type="submit", attrs.name=w.id, attrs.value=w.text.to!string, attrs.style=w.styleStr);
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

import dlangui.widgets.layouts: LinearLayout, Orientation;
@method HtmlFragment _toHtml(LinearLayout w)
{
    final switch(w.orientation)
    {
        case Orientation.Horizontal:
            string ret;

            for(auto i = 0; i < w.childCount; i++)
                ret ~= w.child(i).toHtml.toString(false);

            return tags.div(attrs.style="width: auto; float: left")(ret);

        case Orientation.Vertical:
            string ret;

            for(auto i = 0; i < w.childCount; i++)
                ret ~=
                    tags.div(attrs.style="clear: both")
                    (
                        w.child(i).toHtml
                    ).toString(false);

            return tags.div(attrs.style="float: left")(ret);
    }
}

private:

static this()
{
    updateMethods();
}

string styleStr(Widget w)
{
    auto s = w.ownStyle;

    return
        "font-size: "~s.fontSize.to!string~"px; "~
        "font-weight: "~s.fontWeight.to!string;
}

import dhtags.tags.tag: HtmlTag;

HtmlTag addStyle(HtmlTag tag, Widget w)
{
    import dhtags.attrs.attribute: HtmlAttribute;

    tag.attrs ~= HtmlAttribute("style", w.styleStr);

    return tag;
}
