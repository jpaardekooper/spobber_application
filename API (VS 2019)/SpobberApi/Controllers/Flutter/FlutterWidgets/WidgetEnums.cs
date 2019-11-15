using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public enum TextAlignments
    {
        LEFT,
        RIGHT,
        CENTER,
        JUSTIFY,
        START,
        END
    }

    public enum Overflows
    {
        ELLIPSIS,
        CLIP,
        FADE
    }

    public enum TextDirections
    {
        LTR,
        RTL
    }

    public enum CrossAxisAlignments
    {
        CENTER = 0,
        START = 1,
        END = 2,
        STRETCH = 3,
        BASELINE = 4
    }

    public enum MainAxisAlignments
    {
        START = 0,
        END = 1,
        CENTER = 2,
        SPACE_BETWEEN = 3,
        SPACE_AROUND = 4,
        SPACE_EVENLY = 5
    }

    public enum MainAxisSizes
    {
        MAX = 0,
        MIN = 1
    }

    public enum TextBaselines
    {
        IDEOGRAPHIC = 0,
        ALPHABETIC = 1
    }

    public enum VerticalDirections
    {
        DOWN = 0,
        UP = 1
    }

    public enum Axises
    {
        VERTICAL,
        HORIZONTAL
    }
}