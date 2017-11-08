module formoshlep.platform;

import dlangui;
import dlangui.platforms.common.platform;

private FormoshlepPlatform[size_t] sessions;
private size_t curr_serial;

FormoshlepPlatform getPlatformBySerial(size_t idx)
{
    return sessions[idx];
}

class FormoshlepPlatform : Platform
{
    import formoshlep.window: FormoshlepWindow;

    private FormoshlepWindow window;
    const size_t serial;

    import vibe.http.server: HTTPServerRequest, HTTPServerResponse;

    private const(HTTPServerRequest)* req;
    private HTTPServerResponse res;

    this()
    {
        serial = curr_serial;
        sessions[serial] = this;
        curr_serial++;
    }

    ~this()
    {
        sessions.remove(serial);
    }

    void setServerInputOutput(const HTTPServerRequest req, ref HTTPServerResponse res)
    {
        this.req = &req;
        this.res = res;
    }

    void resetServerInputOutput()
    {
        req = null;
        res = null;
    }

    void genHttpServerResponse()
    {
        assert(window !is null);
        assert(res !is null);

        window.genHttpServerResponse(res);
    }

    override:

    Window createWindow(dstring windowCaption, Window parent, uint flags, uint width, uint height)
    {
        import formoshlep.window;

        assert(window is null);

        window = new FormoshlepWindow(windowCaption);

        return window;
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
