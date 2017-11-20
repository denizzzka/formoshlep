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
    if(!w.enabled)
        return;

    w.readState(req);

    for(auto i = 0; i < w.childCount; i++)
        w.child(i).readWidgetsState(req);
}

void processEvents(Widget w, HTTPServerRequest req)
{
    if(!w.enabled)
        return;

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

import dlangui.widgets.controls: CheckBox;
@method void _readState(CheckBox w, HTTPServerRequest req)
{
    w.checked = (req.form.get(w.id) == w.id);
}
@method FormoEvent[] _getEvents(CheckBox w, HTTPServerRequest req){ return null; }
@method HtmlFragment _toHtml(CheckBox w)
{
    import dhtags.attrs.attribute: HtmlAttribute;

    auto cbox = tags.input(attrs.type="checkbox", attrs.id=w.id, attrs.name=w.id, attrs.value=w.id);

    if(w.checked)
        cbox.attrs ~= HtmlAttribute("checked", "checked");

    if(!w.enabled)
        cbox.attrs ~= HtmlAttribute("disabled", "disabled");

    return
        tags.div(attrs.style="width: auto; float: left")
        (
            cbox,
            tags.label(attrs.for_=w.id)(w.text.to!string)
        );
}

import dlangui.widgets.controls: RadioButton;
@method void _readState(RadioButton w, HTTPServerRequest req)
{
    if(w.checked != (req.form.get(w.parent.id) == w.id))
    {
        w.uncheckSiblings();
        w.checked = true;
    }
}
@method FormoEvent[] _getEvents(RadioButton w, HTTPServerRequest req){ return null; }
@method HtmlFragment _toHtml(RadioButton w)
{
    import dhtags.attrs.attribute: HtmlAttribute;

    auto box = tags.input(attrs.type="radio", attrs.id=w.id, attrs.name=w.parent.id, attrs.value=w.id);

    if(w.checked)
        box.attrs ~= HtmlAttribute("checked", "checked");

    if(!w.enabled)
        box.attrs ~= HtmlAttribute("disabled", "disabled");

    return
        tags.div(attrs.style="width: auto; float: left")
        (
            box,
            tags.label(attrs.for_=w.id)(w.text.to!string)
        );
}

import dlangui.widgets.controls: Button;
private FormoEvent[] checkIfButtonPressed(Widget w, HTTPServerRequest req)
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
@method FormoEvent[] _getEvents(Button w, HTTPServerRequest req)
{
    return checkIfButtonPressed(w, req);
}
@method HtmlFragment _toHtml(Button w)
{
    return tags.input(attrs.type="submit", attrs.name=w.id, attrs.value=w.text.to!string, attrs.style=w.styleStr);
}

import dlangui.widgets.controls: ImageWidget;
@method HtmlFragment _toHtml(ImageWidget w)
{
    assert(w.drawable !is null);

    import dlangui.graphics.resources: drawableCache;

    auto d = w.drawable;

    return tags.img(attrs.src="/res/"~drawableCache._idToDrawableMap[w.drawableId]._filename, attrs.width=d.width, attrs.height=d.height);
}

import dlangui.widgets.controls: ImageTextButton;
@method FormoEvent[] _getEvents(ImageTextButton w, HTTPServerRequest req)
{
    return checkIfButtonPressed(w, req);
}
@method HtmlFragment _toHtml(ImageTextButton w)
{
    return
        tags.button(attrs.type="submit", attrs.name=w.id, attrs.value=w.text.to!string)
        (
            (cast(LinearLayout) w)._toHtml
        );
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
    import std.format;

    auto s = w.ownStyle;

    return
        "color: "~s.textColor.format!"#%06X; "~
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
