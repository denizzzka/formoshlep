module formoshlep.platform;

import dlangui;
import dlangui.platforms.common.platform;

class FormoshlepPlatform : Platform
{
    override:

    Window createWindow(dstring windowCaption, Window parent, uint flags, uint width, uint height)
    {
        import formoshlep.window;

        return new FormoshlepWindow(windowCaption);
    }

    void closeWindow(Window w)
    {
        assert(false, "Isn't implemented");
    }

    /**
    * Starts application message loop.
    *
    * When returned from this method, application is shutting down.
    */
    int enterMessageLoop()
    {
        assert(false, "Isn't implemented");
    }

    bool hasClipboardText(bool mouseBuffer)
    {
        assert(false, "Isn't implemented");
    }

    dstring getClipboardText(bool mouseBuffer)
    {
        assert(false, "Isn't implemented");
    }

    void setClipboardText(dstring text, bool mouseBuffer)
    {
        assert(false, "Isn't implemented");
    }

    void requestLayout()
    {
        //~ if(window !is null)
            //~ window.requestLayout();
    }
}
