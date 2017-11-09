module formoshlep.widget;

import dhtags.tags.tag: HtmlFragment;
import vibe.http.server: HTTPServerRequest;
import std.exception: enforce;
import std.conv: to;
import dhtags;

static import dlangui.widgets.controls;
static import dlangui.dialogs.inputbox;
static import dlangui.widgets.layouts;

import dlangui.core.i18n: UIString;
import dlangui: Window;
import dlangui.core.events;

package struct FormoEvent
{
    KeyEvent keyEvent;
    MouseEvent mouseEvent;
}

interface WebWidget
{
    HtmlFragment toHtml() const; //TODO: make it package

    void readState(HTTPServerRequest req); //TODO: make it package
    FormoEvent[] getEvents(HTTPServerRequest req); //TODO: make it package
}

class TextWidget : dlangui.widgets.controls.TextWidget, WebWidget
{
    this(T = string)(string ID = null, T text = null)
    {
        super(ID, text);
    }

    HtmlFragment toHtml() const
    {
        import std.conv: to;

        return h2(text.to!string); //TODO: replace h2 to more suitable tag
    }

    void readState(in HTTPServerRequest req) {}
    FormoEvent[] getEvents(HTTPServerRequest req) { return null; }
}

class InputBox : dlangui.dialogs.inputbox.InputBox, WebWidget
{
    this(UIString caption, UIString message, Window parentWindow, dstring initialText, void delegate(dstring result) handler)
    {
        enforce(handler == null);
        super(caption, message, parentWindow, initialText, handler);
    }

    HtmlFragment toHtml() const
    {
        return input(type="text", name=id, value=text.to!string);
    }

    void readState(HTTPServerRequest req)
    {
        if(req.form.get(id, "IMPOSSIBLE_VALUE") != "IMPOSSIBLE_VALUE") //FIXME: remove that shit
            text = req.form.get(id).to!dstring;
    }

    //TODO: Rewrite for JS-enabled widget
    FormoEvent[] getEvents(HTTPServerRequest req)
    {
        enforce(action is null);

        return null;
    }
}

class Button : dlangui.widgets.controls.Button, WebWidget
{
    this(string ID, string labelResourceId)
    {
        super(ID, labelResourceId);
    }

    HtmlFragment toHtml() const
    {
        return input(type="submit", name=id, value=text.to!string);
    }

    void readState(in HTTPServerRequest req) {}

    FormoEvent[] getEvents(HTTPServerRequest req)
    {
        if(req.form.get(id) is null)
            return null;
        else
            return
            [
                FormoEvent(null, new MouseEvent(MouseAction.ButtonDown, MouseButton.Left, 0, -10, -10, 0)),
                FormoEvent(null, new MouseEvent(MouseAction.ButtonUp,   MouseButton.Left, 0, -10, -10, 0))
            ];
    }
}

class VerticalLayout : dlangui.widgets.layouts.VerticalLayout, WebWidget
{
    HtmlFragment toHtml() const
    {
        import dhtags.tags.tag: HtmlString;

        string ret;

        for(auto i = 0; i < childCount; i++)
            ret ~= (cast(WebWidget) child(i)).toHtml.toString(false);

        return new HtmlString(ret);
    }

    void readState(in HTTPServerRequest req) {}
    FormoEvent[] getEvents(HTTPServerRequest req) { return null; }
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
