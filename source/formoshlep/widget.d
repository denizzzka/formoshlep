module formoshlep.widget;

import dhtags.tags.tag: HtmlFragment, HtmlString;
import vibe.http.server: HTTPServerRequest;
import std.exception: enforce;
import std.conv: to;
import dhtags;

import dlangui.core.events;
import dlangui.widgets.widget: Widget;

package struct FormoEvent
{
    KeyEvent keyEvent;
    MouseEvent mouseEvent;
}

alias ReadStateCallback = void delegate(Widget, HTTPServerRequest);
alias GenHtmlCallback = HtmlFragment delegate(in Widget); // TODO: pure
alias GetEventsCallback = FormoEvent[] delegate(Widget, HTTPServerRequest); // TODO: pure

private enum NAME = "Widget";

static this()
{
    import dlangui.widgets.controls: TextWidget;

    TextWidget.customMethod!(NAME~".readState")
    (
        Widget.CustomMethodArgs!ReadStateCallback
        (
            (Widget w, HTTPServerRequest req){}
        ),
        null
    );

    TextWidget.customMethod!(NAME~".toHtml") = Widget.CustomMethodArgs!GenHtmlCallback
    (
        (in Widget w)
        {
            import std.conv: to;

            return new HtmlString(w.text.to!string);
        }
    );

    TextWidget.customMethod!(NAME~".getEvents")
    (
        Widget.CustomMethodArgs!GetEventsCallback
        (
            (Widget w, HTTPServerRequest req)
            {
                enforce(w.action is null);
                FormoEvent[] empty_ret;
                return empty_ret;
            }
        ),

        null
    );
}

static this()
{
    import dlangui.widgets.editors: EditLine;

    EditLine.customMethod!(NAME~".readState")
    (
        Widget.CustomMethodArgs!ReadStateCallback
        (
            (Widget w, HTTPServerRequest req)
            {
                auto e = cast(EditLine) w;

                if(req.form.get(e.id, "IMPOSSIBLE_VALUE") != "IMPOSSIBLE_VALUE") //FIXME: remove that shit
                    e.text = req.form.get(e.id).to!dstring;
            }
        ),

        null
    );

    EditLine.customMethod!(NAME~".toHtml") = Widget.CustomMethodArgs!GenHtmlCallback
    (
        (in Widget w)
        {
            auto e = cast(EditLine) w;

            return input(type="text", name=e.id, value=e.text.to!string);
        }
    );

    EditLine.customMethod!(NAME~".getEvents")
    (
        Widget.CustomMethodArgs!GetEventsCallback
        (
            (Widget w, HTTPServerRequest req)
            {
                enforce(w.action is null);

                FormoEvent[] empty_ret;

                return empty_ret;
            }
        ),

        null
    );
}

static this()
{
    import dlangui.widgets.controls: Button;

    Button.customMethod!(NAME~".readState")
    (
        Widget.CustomMethodArgs!ReadStateCallback
        (
            (Widget w, HTTPServerRequest req){}
        ),
        null
    );

    Button.customMethod!(NAME~".toHtml") = Widget.CustomMethodArgs!GenHtmlCallback
    (
        (in Widget w)
        {
            return input(type="submit", name=w.id, value=w.text.to!string);
        }
    );

    Button.customMethod!(NAME~".getEvents")
    (
        Widget.CustomMethodArgs!GetEventsCallback
        (
            (Widget w, HTTPServerRequest req)
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
        ),

        null
    );
}

static this()
{
    import dlangui.widgets.layouts: LinearLayout, Orientation;

    LinearLayout.customMethod!(NAME~".readState")
    (
        Widget.CustomMethodArgs!ReadStateCallback
        (
            (Widget w, HTTPServerRequest req){}
        ),
        null
    );

    LinearLayout.customMethod!(NAME~".toHtml") = Widget.CustomMethodArgs!GenHtmlCallback
    (
        (in Widget w)
        {
            auto lay = cast(const LinearLayout) w;

            //~ final switch(lay.orientation) // TODO: make dlangui's orientation() const
            final switch(Orientation.Horizontal) // TODO: make dlangui's orientation() const
            {
                case Orientation.Horizontal:
                    string ret;

                    for(auto i = 0; i < w.childCount; i++)
                        ret ~= w.child(i).toHtml.toString(false);

                    return div(attrs.style="width: auto; float: left")(ret);

                case Orientation.Vertical:
                    string ret;

                    for(auto i = 0; i < w.childCount; i++)
                        ret ~=
                            div(attrs.style="clear: both")
                            (
                                w.child(i).toHtml
                            ).toString(false);

                    return div(attrs.style="float: left")(ret);
            }
        }
    );

    LinearLayout.customMethod!(NAME~".getEvents")
    (
        Widget.CustomMethodArgs!GetEventsCallback
        (
            (Widget w, HTTPServerRequest req)
            {
                enforce(w.action is null);

                FormoEvent[] empty_ret;

                return empty_ret;
            }
        ),

        null
    );
}

HtmlFragment toHtml(in Widget w)
{
    auto h = Widget.customMethod!(NAME~".toHtml")(Widget.CustomMethodArgs!GenHtmlCallback(w));

    return (h is null) ? new HtmlString("") : h;
}

FormoEvent[] getEvents(Widget w, HTTPServerRequest req)
{
    return Widget.customMethod!(NAME~".getEvents")(Widget.CustomMethodArgs!GetEventsCallback(w), req);
}

void readWidgetsState(dlangui.widgets.widget.Widget w, HTTPServerRequest req)
{
    //~ w.readState(req);

    for(auto i = 0; i < w.childCount; i++)
        w.child(i).readWidgetsState(req);
}

void processEvents(dlangui.widgets.widget.Widget w, HTTPServerRequest req)
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
