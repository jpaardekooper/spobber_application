using System.Collections.Generic;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class Container : Widget
    {
        public List<Widget> Children { get; set; } = new List<Widget>();
    }
}