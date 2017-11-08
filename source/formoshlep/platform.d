module formoshlep.platform;

import dlangui;
import dlangui.platforms.common.platform;

class FormoshlepPlatform : Platform
{
    import formoshlep.window;
    import vibe.http.server;

    private FormoshlepWindow window;

    private HTTPServerSettings _httpServerSettings;

    private const(HTTPServerRequest)* req; //TODO: remove it
    private HTTPServerResponse res; //TODO: remove it

    void httpServerSettings(HTTPServerSettings s)
    {
        _httpServerSettings = s;
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

    void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
    {
        setServerInputOutput(req, res);

        //~ if (req.path != "/")
            //~ res.writeBody("Unknown path");
        //~ else
        {
            assert(window !is null);
            assert(req !is null);
            assert(res !is null);

            import formoshlep.widget;

            window.mainWidget.readWidgetsState(req);
            window.mainWidget.processEvents(req);
            window.genHttpServerResponse(res);
        }

        resetServerInputOutput();
    }

    override:

    Window createWindow(dstring windowCaption, Window parent, uint flags, uint width, uint height)
    {
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
        import vibe.core.core: runApplication;

        listenHTTP(_httpServerSettings, &handleRequest);
        runApplication();

        return 0;
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
