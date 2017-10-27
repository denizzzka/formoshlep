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

    override:

    void close()
    {
        assert(false, __FUNCTION__~" isn't implemented");
    }

    /// Displays window at the first time
    void show()
    {
        assert(false, __FUNCTION__~" isn't implemented");
    }

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

    void invalidate()
    {
    }
}
