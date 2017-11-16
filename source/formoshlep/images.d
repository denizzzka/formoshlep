module formoshlep.images;

import dlangui.graphics.drawbuf;

package:

ImageDrawBuf loadImageFromStream(immutable ubyte[] stream, string filename)
{
    import dlangui.graphics.images: origLoad = loadImageFromStream;

    ColorDrawBuf ret = origLoad(stream, filename);

    return new ImageDrawBuf(filename, ret);
}

class ImageDrawBuf : ColorDrawBuf
{
    private static string[string] availableImages;
    private string filename;

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
