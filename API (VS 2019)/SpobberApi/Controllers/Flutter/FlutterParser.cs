using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Reflection;

using SpobberApi.Models;
using SpobberApi.Controllers.Flutter.FlutterWidgets;

namespace SpobberApi.Controllers.Flutter
{
    public class FlutterParser
    {
        private object parseObject;
        private Type objectType;

        private string finalJson;

        public FlutterParser(Type type, object objectClass)
        {
            parseObject = objectClass;
            objectType = type;
        }

        public string ParseObject(ContainerTypes containerType)
        {
            Container container;
            switch (containerType)
            {
                case ContainerTypes.COLUMN:
                    container = new ColumnContainer();
                    break;
                case ContainerTypes.ROW:
                    container = new RowContainer();
                    break;
                case ContainerTypes.LISTVIEW:
                    container = new ListViewContainer();
                    break;
                default:
                    container = new ListViewContainer();
                    break;
            }
            
            PropertyInfo[] properties = objectType.GetProperties();
            foreach (PropertyInfo property in properties)
            {
                if (property.GetValue(parseObject) != null || string.IsNullOrEmpty(property.GetValue(parseObject).ToString()))
                {
                    string name = property.PropertyType.Name;
                    switch (name)
                    {
                        case "String":
                            container.Children.Add(new CardWidget(new ListTileWidget("content_paste", property.Name, property.GetValue(parseObject).ToString())));
                            break;
                        case "Int32":
                            container.Children.Add(new CardWidget(new ListTileWidget("content_paste", property.Name, property.GetValue(parseObject).ToString())));
                            break;
                    }
                }
            }
            finalJson = container.ToString();
            return finalJson;
        }

        public enum ContainerTypes
        {
            COLUMN      =   0,
            ROW         =   1,
            LISTVIEW    =   2
        }
    }
}