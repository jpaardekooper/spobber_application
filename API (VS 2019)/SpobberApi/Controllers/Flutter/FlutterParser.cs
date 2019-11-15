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
                    container = new Column();
                    break;
                case ContainerTypes.ROW:
                    container = new Row();
                    break;
                default:
                    container = new Column();
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
                            Row row = new Row();
                            row.Children.Add(new IconWidget());
                            row.Children.Add(new TextWidget((string)property.GetValue(parseObject)));
                            container.Children.Add(row);
                            break;
                        case "Int32":
                            container.Children.Add(new TextWidget(property.GetValue(parseObject).ToString()));
                            break;
                    }
                }
            }
            finalJson = container.ToString();
            return finalJson;
        }

        public enum ContainerTypes
        {
            COLUMN  =   0,
            ROW     =   1
        }
    }
}