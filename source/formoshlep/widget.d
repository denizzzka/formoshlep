module formoshlep.widget;

import dht = dhtags;
import attrs = dhtags.attrs;
import dhtags.tags.tag: HtmlFragment, HtmlString;
import vibe.http.server: HTTPServerRequest;
import std.exception: enforce;
import std.conv: to;
import openmethods;
mixin(registerMethods);

import dlangui.widgets.widget: Widget;
import dlangui.widgets.controls: TextWidget;
import dlangui.widgets.editors: EditLine;
import dlangui.widgets.layouts: LinearLayout, Orientation;

//~ import dlangui: Window;
import dlangui.core.events;

package struct FormoEvent
{
    KeyEvent keyEvent;
    MouseEvent mouseEvent;
}

void readState(virtual!(const Widget), virtual!(const HTTPServerRequest));
FormoEvent[] getEvents(virtual!Widget, virtual!(const HTTPServerRequest));
HtmlFragment toHtml(virtual!(const Widget));

// Custom Widget methods:
@method void _readState(in Widget w, in HTTPServerRequest req) {}
@method HtmlFragment _toHtml(in Widget w) { return new HtmlString(""); }
@method FormoEvent[] _getEvents(Widget w, HTTPServerRequest req) { return null; }

// TextWidget:
@method HtmlFragment _toHtml(in TextWidget w)
{
    return new HtmlString(w.text.to!string);
}

// EditLine:
@method HtmlFragment _toHtml(in EditLine w)
{
    return dht.input(attrs.type="text", attrs.name=w.id, attrs.value=w.text.to!string);
}

//~ class EditLine : dlangui.widgets.editors.EditLine, WebWidget
//~ {

    //~ HtmlFragment toHtml() const
    //~ {
        //~ return input(type="text", name=id, value=text.to!string);
    //~ }

    //~ void readState(HTTPServerRequest req)
    //~ {
        //~ if(req.form.get(id, "IMPOSSIBLE_VALUE") != "IMPOSSIBLE_VALUE") //FIXME: remove that shit
            //~ text = req.form.get(id).to!dstring;
    //~ }

    //~ //TODO: Rewrite for JS-enabled widget
    //~ FormoEvent[] getEvents(HTTPServerRequest req)
    //~ {
        //~ enforce(action is null);

        //~ return null;
    //~ }
//~ }

//~ class Button : dlangui.widgets.controls.Button, WebWidget
//~ {
    //~ this(string ID, string labelResourceId)
    //~ {
        //~ super(ID, labelResourceId);
    //~ }

    //~ HtmlFragment toHtml() const
    //~ {
        //~ return input(type="submit", name=id, value=text.to!string);
    //~ }

    //~ void readState(in HTTPServerRequest req) {}

    //~ FormoEvent[] getEvents(HTTPServerRequest req)
    //~ {
        //~ if(req.form.get(id) is null)
            //~ return null;
        //~ else
            //~ return
            //~ [
                //~ FormoEvent(null, new MouseEvent(MouseAction.ButtonDown, MouseButton.Left, 0, -10, -10, 0)),
                //~ FormoEvent(null, new MouseEvent(MouseAction.ButtonUp,   MouseButton.Left, 0, -10, -10, 0))
            //~ ];
    //~ }
//~ }

//~ class LinearLayout : dlangui.widgets.layouts.LinearLayout, WebWidget
//~ {
    //~ this()
    //~ {
        //~ this(null);
    //~ }

    //~ /// create with ID parameter and orientation
    //~ this(string ID, Orientation orientation = Orientation.Vertical)
    //~ {
        //~ super(ID, orientation);
    //~ }

    //~ HtmlFragment toHtml() const
    //~ {
        //~ final switch(_orientation) // TODO: make dlangui's orintation() const
        //~ {
            //~ case Orientation.Horizontal:
                //~ string ret;

                //~ for(auto i = 0; i < childCount; i++)
                    //~ ret ~= (cast(WebWidget) child(i)).toHtml.toString(false);

                //~ return div(attrs.style="width: auto; float: left")(ret);

            //~ case Orientation.Vertical:
                //~ string ret;

                //~ for(auto i = 0; i < childCount; i++)
                    //~ ret ~=
                        //~ div(attrs.style="clear: both")
                        //~ (
                            //~ (cast(WebWidget) child(i)).toHtml
                        //~ ).toString(false);

                //~ return div(attrs.style="float: left")(ret);
        //~ }
    //~ }

    //~ void readState(in HTTPServerRequest req) {}
    //~ FormoEvent[] getEvents(HTTPServerRequest req) { return null; }
//~ }

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
