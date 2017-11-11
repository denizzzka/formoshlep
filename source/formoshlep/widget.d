module formoshlep.widget;

import dhtags.tags.tag: HtmlFragment;
import vibe.http.server: HTTPServerRequest;
import std.exception: enforce;
import std.conv: to;
import dhtags;

import dlangui.core.i18n: UIString;
import dlangui: Window;
import dlangui.core.events;

import dlangui.widgets.widget;
import dlangui.widgets.editors: EditLine;
import dlangui.widgets.layouts: LinearLayout;

package struct FormoEvent
{
    KeyEvent keyEvent;
    MouseEvent mouseEvent;
}

alias ReadStateCallback = void delegate(Widget, HTTPServerRequest);
alias GenHtmlCallback = HtmlFragment delegate(Widget); // TODO: pure
alias GetEventsCallback = FormoEvent[] delegate(Widget, HTTPServerRequest); // TODO: pure

interface WebWidget
{
    HtmlFragment toHtml() const; //TODO: make it package

    void readState(HTTPServerRequest req); //TODO: make it package
    FormoEvent[] getEvents(HTTPServerRequest req); //TODO: make it package
}

static this()
{
    enum NAME = "TextWidget";

    EditLine.customMethod!(NAME~".readState")
    (
        Widget.CustomMethodArgs!ReadStateCallback
        (
            (Widget w, HTTPServerRequest req){}
        ),
        null
    );

    EditLine.customMethod!(NAME~".toHtml") = Widget.CustomMethodArgs!GenHtmlCallback
    (
        (Widget w)
        {
            import dhtags.tags.tag: HtmlString;
            import std.conv: to;

            return new HtmlString(w.text.to!string);
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
    enum NAME = "EditLine";

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
        (Widget w)
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
    enum NAME = "Button";

    EditLine.customMethod!(NAME~".readState")
    (
        Widget.CustomMethodArgs!ReadStateCallback
        (
            (Widget w, HTTPServerRequest req){}
        ),
        null
    );

    EditLine.customMethod!(NAME~".toHtml") = Widget.CustomMethodArgs!GenHtmlCallback
    (
        (Widget w)
        {
            return input(type="submit", name=w.id, value=w.text.to!string);
        }
    );

    EditLine.customMethod!(NAME~".getEvents")
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
    enum NAME = "LinearLayout";

    EditLine.customMethod!(NAME~".readState")
    (
        Widget.CustomMethodArgs!ReadStateCallback
        (
            (Widget w, HTTPServerRequest req){}
        ),
        null
    );

    EditLine.customMethod!(NAME~".toHtml") = Widget.CustomMethodArgs!GenHtmlCallback
    (
        (Widget w)
        {
            auto lay = cast(LinearLayout) w;

            final switch(lay.orientation) // TODO: make dlangui's orintation() const
            {
                case Orientation.Horizontal:
                    string ret;

                    for(auto i = 0; i < w.childCount; i++)
                        ret ~= (cast(WebWidget) w.child(i)).toHtml.toString(false);

                    return div(attrs.style="width: auto; float: left")(ret);

                case Orientation.Vertical:
                    string ret;

                    for(auto i = 0; i < w.childCount; i++)
                        ret ~=
                            div(attrs.style="clear: both")
                            (
                                (cast(WebWidget) w.child(i)).toHtml
                            ).toString(false);

                    return div(attrs.style="float: left")(ret);
            }
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

void readWidgetsState(dlangui.widgets.widget.Widget w, HTTPServerRequest req)
{
    (cast(WebWidget) w).readState(req);

    for(auto i = 0; i < w.childCount; i++)
        w.child(i).readWidgetsState(req);
}

void processEvents(dlangui.widgets.widget.Widget w, HTTPServerRequest req)
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
