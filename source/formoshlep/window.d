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
    import formoshlep.widget: WebWidget;

    package void genHttpServerResponse(ref HTTPServerResponse res)
    {
        import formoshlep: toString;

        res.writeBody(toHtml.toString, "text/html; charset=UTF-8");
    }

    import formoshlep: HtmlDocPiece;

    private HtmlDocPiece toHtml() const
    {
        import dhtags;
        import formoshlep: toString;

        assert(mainWidget !is null);

        return HtmlDocPiece([
            html
            (
                head
                (
                    //~ title(mainWidget.caption)
                ),

                body_
                (
                    (cast(WebWidget) mainWidget).toHtml.toString
                )
            ).toString
        ]);
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
