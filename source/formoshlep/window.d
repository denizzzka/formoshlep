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
        res.writeBody(toHtml.toString(false), "text/html; charset=UTF-8");
    }

    import dhtags.tags.tag: HtmlFragment, HtmlString;

    private HtmlFragment toHtml() const
    {
        import dhtags;
        import std.conv: to;

        assert(mainWidget !is null);

        return
            html
            (
                head
                (
                    tags.title
                    (
                        windowCaption().to!string
                    )
                ),

                body_
                (
                    tags.form(enctype="multipart/form-data", action=".", method="post")
                    (
                        (cast(WebWidget) mainWidget).toHtml.toString(false)
                    )
                )
            );
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
