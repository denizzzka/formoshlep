module formoshlep.window;

import dlangui;

class FormoshlepWindow : Window
{
    private string caption;

    this(dstring caption)
    {
        windowOrContentResizeMode = WindowOrContentResizeMode.shrinkWidgets;
        super();

        //~ BT.open(caption.to!string);

        // set background color:
        {
            //~ BT.bkcolor(backgroundColor);
            //~ BT.clear();
            //~ BT.refresh();
        }
    }

    ~this()
    {
        close();
    }

    import vibe.http.server: HTTPServerResponse;

    package void genHttpServerResponse(ref HTTPServerResponse res)
    {
        import formoshlep.widget: WebWidget;
        import formoshlep: toString;

        assert(mainWidget !is null);

        res.writeBody((cast(WebWidget) mainWidget).toHtml.toString, "text/html; charset=UTF-8");
    }

    override:

    void close()
    {
        assert(false, __FUNCTION__~" isn't implemented");
    }

    /// Displays window at the first time
    void show() {}

    dstring windowCaption() @property
    {
        return caption.to!dstring;
    }

    void windowCaption(dstring caption) @property
    {
        this.caption = caption.to!string;
    }

    void windowIcon(DrawBufRef icon) @property
    {
        assert(false, __FUNCTION__~" isn't implemented");
    }

    void invalidate() {}
}
