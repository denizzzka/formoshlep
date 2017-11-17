module formoshlep.images;

import dlangui.graphics.drawbuf;

package:

class ImageDrawBuf : ColorDrawBuf
{
    private static string[string] availableImages;
    private const string filename;

    this(string _filename, ColorDrawBuf drawBuf)
    {
        filename = _filename;
        availableImages[filename] = filename;

        super(drawBuf); //FIXME this values
    }

    static bool isAvailable(string filename)
    {
        return (filename in availableImages) !is null;
    }
}
