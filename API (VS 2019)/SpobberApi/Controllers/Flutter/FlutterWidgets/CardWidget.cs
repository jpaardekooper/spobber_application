using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class CardWidget : Widget
    {
        public Widget Child { get; set; }

        public CardWidget(Widget child)
        {
            Child = child;
        }

        public override string ToString()
        {
            return $"{{" +
                $"\"type\": \"Card\"," +
                $"\"child\": {Child.ToString()}" +
                $"}}";
        }
    }
}