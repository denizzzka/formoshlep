module formoshlep.images;

import dlangui.graphics.drawbuf;

package:

ImageDrawBuf loadImageFromStream(immutable ubyte[] stream, string filename)
{
    return new ImageDrawBuf(filename);
}

class ImageDrawBuf : ColorDrawBuf
{
    private string[string] availableImages;

    this(string filename)
    {
        availableImages[filename] = filename;

        super(10, 10); //FIXME this values
    }

    bool isAvailable(string filename)
    {
        return (filename in availableImages) !is null;
    }
}
