using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class TextWidget : Widget
    {
        public string Data { get; set; } = string.Empty;
        public TextAlignments TextAlign { get; set; } = TextAlignments.LEFT;
        public Overflows Overflow { get; set; } = Overflows.ELLIPSIS;
        public int MaxLines { get; set; } = 1;
        public string SemanticsLabel { get; set; } = string.Empty;
        public bool SoftWrap { get; set; } = true;
        public TextDirections TextDirection { get; set; } = TextDirections.LTR;
        public double TextScaleFactor { get; set; } = 1.0;

        public TextWidget(string data)
        {
            Data = data;
        }

        public override string ToString()
        {
            return $"{{" +
                $"\"type\": \"Text\"," +
                $"\"data\": \"{Data}\"," +
                $"\"textAlign\": \"{TextAlign.ToString().ToLower()}\"," +
                $"\"overflow\": \"{Overflow.ToString().ToLower()}\"," +
                $"\"maxLines\": {MaxLines}," +
                $"\"semanticsLabel\": \"{SemanticsLabel}\"," +
                $"\"softWrap\": {SoftWrap.ToString().ToLower()}," +
                $"\"textDirection\": \"{TextDirection.ToString().ToLower()}\"," +
                $"\"textScaleFactor\": {TextScaleFactor.ToString("0.00")}" +
                $"}}";
        }

    }
}