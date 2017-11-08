module formoshlep.window;

import dlangui;

class FormoshlepWindow : Window
{
    private dstring caption;

    this(dstring caption)
    {
        this.caption = caption;
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
        import formoshlep: toString;
        import std.conv: to;

        assert(mainWidget !is null);

        return HtmlDocPiece([
            "
            <html>
                <head>
                    <title>"~windowCaption().to!string~"</title>
                </head>
                <body>
                    <form enctype='multipart/form-data' action='./' method='post'>
                        "~(cast(WebWidget) mainWidget).toHtml.toString~"
                    </form>
                </body>
            </html>
            "
        ]);
    }

    override:

    void close()
    {
        assert(false, __FUNCTION__~" isn't implemented");
    }

    /// Displays window at the first time
    void show() {}

    dstring windowCaption() const @property
    {
        return caption;
    }

    void windowCaption(dstring caption) @property
    {
        this.caption = caption;
    }

    void windowIcon(DrawBufRef icon) @property
    {
        assert(false, __FUNCTION__~" isn't implemented");
    }

    void invalidate() {}
}
