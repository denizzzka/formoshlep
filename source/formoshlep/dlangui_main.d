module formoshlep.dlangui_main;

import dlangui;

extern(C) int DLANGUImain(string[] args)
{
    import formoshlep.platform: FormoshlepPlatform;
    import formoshlep.fonts: FormoshlepFontManager;

    initLogs();
    Log.setLogLevel = LogLevel.Debug;
    SCREEN_DPI = 10; // TODO: wtf?
    Platform.setInstance = new FormoshlepPlatform();
    FontManager.instance = new FormoshlepFontManager();
    initResourceManagers();

    version (Windows)
    {
        import core.sys.windows.winuser;
        DOUBLE_CLICK_THRESHOLD_MS = GetDoubleClickTime();
    }

    currentTheme = createDefaultTheme();
    Platform.instance.uiTheme = "theme_default";

    Log.i("Entering UIAppMain: ", args);

    int result = -1;
    try
    {
        version(unittest)
        {
            result = 0;
        }
        else
        {
            result = UIAppMain(args);
            Log.i("UIAppMain returned ", result);
        }
    }
    catch (Exception e)
    {
        Log.e("Abnormal UIAppMain termination");
        Log.e("UIAppMain exception: ", e);
    }

    Platform.setInstance(null);

    releaseResourcesOnAppExit();

    Log.d("Exiting main");
    APP_IS_SHUTTING_DOWN = true;

    return result;
}
