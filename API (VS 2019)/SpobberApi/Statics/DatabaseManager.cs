using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

using SpobberApi.Models;

namespace SpobberApi.Statics
{
    public static class DatabaseManager
    {
        private static SqlConnectionStringBuilder connectionString;
        private static int _clusterMax = 2000;

        private enum Sources
        {
            SAP,
            SIGMA,
            UST02
        }

        private static Dictionary<string, int> SAP = new Dictionary<string, int>()
        {
            { "secret-id", 0 },
            { "equipment", 1 },
            { "description", 2 },
            { "status", 3 },
            { "latitude", 4 },
            { "longitude", 5 },
            { "user_status_equi", 6 },
            { "parent_equi_kind", 7 },
            { "datacollection", 8 },
            { "placement", 9 },
            { "year", 10 },
            { "type_eslas", 11 },
            { "rating", 12 }
        };

        private static Dictionary<string, int> SIGMA = new Dictionary<string, int>()
        {
            { "secret-id", 0 },
            { "latitude", 1 },
            { "longitude", 2 },
            { "idtxt2", 3 },
            { "year", 4 },
            { "rating", 5 }
        };

        private static Dictionary<string, int> UST02 = new Dictionary<string, int>()
        {
            { "secret-id", 0 },
            { "pic_file_name", 1 },
            { "window_file_name", 2 },
            { "run_nr", 3 },
            { "track", 4 },
            { "track_version", 5},
            { "latitude", 6 },
            { "longitude", 7 },
            { "year", 8 },
            { "rating", 9 }
        };

        public static void Initialize()
        {
            connectionString = new SqlConnectionStringBuilder()
            {
                DataSource = "spobberdata.database.windows.net",
                UserID = "KIIdkvp_038-",
                Password = "Nvldsau(#)-;",
                InitialCatalog = "spobber_db"
            };
        }

        public static string BindPictureToObject(string objectId, string imageExtension)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                string returnValue = string.Empty;
                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"INSERT INTO dbo.user_image (id, type, image_extension, year) " +
                    $"OUTPUT Inserted.image_id " +
                    $"VALUES ('{objectId}', " +
                    $"(SELECT type FROM dbo.object WHERE id = '{objectId}'), '{imageExtension}', {DateTime.Now.Year});";

                returnValue = ((Guid)command.ExecuteScalar()).ToString();
                return returnValue;
            }
        }

        public static void UnbindPictureToObject(string imageId)
        {
            using(SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"DELETE FROM dbo.user_image WHERE image_id = '{imageId}'";
                command.ExecuteNonQuery();
            }
        }

        public static ShortRailObject[] GetShortRailObjects(ObjectRequest request, string[] dataSources, bool cluster)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                List<ShortRailObject> result = new List<ShortRailObject>();
                SqlCommand command = _connection.CreateCommand();

                for (int i = 0; i < dataSources.Length; i++)
                {
                    Enum.TryParse<Sources>(dataSources[i], out Sources source);
                    switch (source)
                    {
                        case Sources.SAP:
                            command.CommandText = "SELECT equipment, sap_id, placement, latitude, longitude FROM dbo.sap";
                            break;
                        case Sources.SIGMA:
                            command.CommandText = "SELECT sigma_id, latitude, longitude FROM dbo.sigma";
                            break;
                        case Sources.UST02:
                            command.CommandText = "SELECT ust02_id, latitude, longitude FROM dbo.ust02";
                            break;
                    }
                    command.CommandText +=
                    $" WHERE latitude BETWEEN {request.BLat} AND {request.NLat} " +
                    $"AND longitude BETWEEN {request.BLon} AND {request.NLon}";

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        int clusterCount = 0;
                        if (cluster)
                            while (clusterCount < _clusterMax / dataSources.Length && reader.Read())
                            {
                                switch (source)
                                {
                                    case Sources.SAP:
                                        result.Add(new ShortRailObject(reader.GetInt32(0), reader.GetGuid(1).ToString(), "ES-LAS", reader.GetString(2), reader.GetDouble(3), reader.GetDouble(4), dataSources[i].ToUpper()));
                                        break;
                                    case Sources.SIGMA:
                                        result.Add(new ShortRailObject(0, reader.GetGuid(0).ToString(), "ES-LAS", "", reader.GetDouble(1), reader.GetDouble(2), dataSources[i].ToUpper()));
                                        break;
                                    case Sources.UST02:
                                        result.Add(new ShortRailObject(0, reader.GetGuid(0).ToString(), "ES-LAS", "", reader.GetDouble(1), reader.GetDouble(2), dataSources[i].ToUpper()));
                                        break;
                                }
                                clusterCount++;
                            }
                        else
                        {
                            while (reader.Read())
                            {
                                switch (source)
                                {
                                    case Sources.SAP:
                                        result.Add(new ShortRailObject(reader.GetInt32(0), reader.GetGuid(1).ToString(), "ES-LAS", reader.GetString(2), reader.GetDouble(3), reader.GetDouble(4), dataSources[i].ToUpper()));
                                        break;
                                    case Sources.SIGMA:
                                        result.Add(new ShortRailObject(0, reader.GetGuid(0).ToString(), "ES-LAS", "", reader.GetDouble(1), reader.GetDouble(2), dataSources[i].ToUpper()));
                                        break;
                                    case Sources.UST02:
                                        result.Add(new ShortRailObject(0, reader.GetGuid(0).ToString(), "ES-LAS", "", reader.GetDouble(1), reader.GetDouble(2), dataSources[i].ToUpper()));
                                        break;
                                }
                                clusterCount++;
                            }
                        }
                    }
                }
                return result.ToArray();
            }
        }

        public static ShortRailObject GetShortRailObject(int id)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                List<ShortRailObject> result = new List<ShortRailObject>();
                SqlCommand command = _connection.CreateCommand();

                command.CommandText = $"SELECT equipment, id, placement, latitude, longitude, source FROM dbo.object " +
                    $"WHERE equipment = {id};";

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new ShortRailObject(reader.GetInt32(0), reader.GetGuid(1).ToString(), "ES-Las", reader.GetString(2), reader.GetDouble(3), reader.GetDouble(4), reader.GetString(5));
                    }
                }
                return new ShortRailObject();
            }
        }

        public static RailObject GetRailObject(string id)
        {
            RailObject returnObject;
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();

                SqlCommand command = _connection.CreateCommand();
                string source = GetSource(id).ToLower();
                command.CommandText = $"SELECT * FROM dbo.{source} " +
                    $"WHERE {source}_id = '{id}';";
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                        returnObject =  reader.GetRailobject(GetSource(id));
                    else
                        return new RailObject();
                }
            }
            returnObject.AssignImages(GetImages(id));
            return returnObject;
        }

        public static RailObject GetRailObject(int id)
        {
            RailObject returnObject;
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();

                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"SELECT * FROM dbo.object " +
                    $"WHERE equipment = {id};";
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        returnObject = new RailObject
                            (
                            id,
                            reader.GetGuid(0).ToString(),
                            reader.SafeGetString(1),

                            reader.SafeGetString(3),
                            reader.SafeGetString(4),
                            reader.SafeGetString(5),
                            reader.SafeGetString(6),
                            reader.SafeGetString(7),
                            reader.SafeGetString(8),

                            (float)reader.GetDouble(10),
                            (float)reader.GetDouble(11),

                            reader.SafeGetString(12),
                            reader.SafeGetString(14),
                            reader.SafeGetString(15),
                            reader.SafeGetString(16),
                            reader.GetInt32(17),
                            new string[] { }
                            );
                    }
                    else
                    {
                        return new RailObject();
                    }
                }
            }
            returnObject.AssignImages(GetImages(returnObject.Secret_ID));
            return returnObject;
        }

        public static string GetSource(string id)
        {
            using(SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"SELECT * FROM dbo.sap WHERE sap_id = '{id}'";
                if (command.ExecuteScalar() != null)
                    return "SAP";

                command.CommandText = $"SELECT * FROM dbo.sigma WHERE sigma_id = '{id}'";
                if (command.ExecuteScalar() != null)
                    return "SIGMA";
                else
                    return "UST02";
            }
        }

        public static string[] GetImages(string id)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                List<string> images = new List<string>();

                //Get image from window_file_name
                SqlCommand windowFileNameCommand = _connection.CreateCommand();
                windowFileNameCommand.CommandText = $"SELECT window_file_name FROM dbo.object WHERE id = '{id}';";

                string scalarValue = (string)windowFileNameCommand.ExecuteScalar() ?? "";
                if (scalarValue != "")
                {
                    if (scalarValue != null && scalarValue != string.Empty)
                        images.Add(scalarValue);
                }

                //Get images from user_image
                SqlCommand userImageCommand = _connection.CreateCommand();
                userImageCommand.CommandText = $"SELECT image_id, image_extension FROM dbo.user_image WHERE id = '{id}';";
                using (SqlDataReader reader = userImageCommand.ExecuteReader())
                {
                    while (reader.Read())
                        if (reader.GetGuid(0).ToString() != null && reader.GetGuid(0).ToString() != string.Empty)
                            images.Add(reader.GetGuid(0).ToString() + "." + reader.SafeGetString(1));
                }

                return images.ToArray();
            }
        }

        public static ObjectImage[] GetObjectImages(string id)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                List<ObjectImage> images = new List<ObjectImage>();

                //Get image from window_file_name
                SqlCommand windowFileNameCommand = _connection.CreateCommand();
                windowFileNameCommand.CommandText = $"SELECT window_file_name, year, pic_file_name FROM dbo.object WHERE id = '{id}';";

                using(SqlDataReader reader = windowFileNameCommand.ExecuteReader())
                {
                    reader.Read();
                    if (reader.SafeGetString(0) != null && reader.SafeGetString(0) != string.Empty)
                        images.Add(new ObjectImage(reader.GetInt32(1), reader.SafeGetString(0), reader.SafeGetString(0).Split('.')[0], reader.SafeGetString(0).Split('.').Last()));
                    if (reader.SafeGetString(2) != null && reader.SafeGetString(2) != string.Empty)
                    {
                        string[] splitFileName = reader.SafeGetString(0).Split('_');
                        Array.Resize(ref splitFileName, splitFileName.Length - 3);
                        images.Add(new ObjectImage(reader.GetInt32(1), string.Join("_", splitFileName) + '_' + reader.SafeGetString(2), reader.SafeGetString(2).Split('.')[0], reader.SafeGetString(2).Split('.').Last()));
                    }
                }

                //Get images from user_image
                SqlCommand userImageCommand = _connection.CreateCommand();
                userImageCommand.CommandText = $"SELECT image_id, image_extension, year FROM dbo.user_image WHERE id = '{id}';";
                using (SqlDataReader reader = userImageCommand.ExecuteReader())
                {
                    while (reader.Read())
                        if (reader.GetGuid(0).ToString() != null && reader.GetGuid(0).ToString() != string.Empty)
                            images.Add(new ObjectImage(reader.SafeGetInt(2), reader.GetGuid(0).ToString() + "." + reader.SafeGetString(1), reader.GetGuid(0).ToString(), reader.SafeGetString(1)));
                }

                return images.ToArray();
            }
        }

        public static void UpdateRailObject(RailObject railObject)
        {
            //_connection.Open();
            //SqlCommand command = _connection.CreateCommand();
            //command.CommandText = "UPDATE dbo.object " +
            //    $"SET status = {railObject.status} " +
            //    $"WHERE Indication_nr = {railObject.id};";
            //command.ExecuteNonQuery();
            //_connection.Close();
        }

        public static MeasureCollection GetMeasureCollection(MapRequest request)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                List<MapMeasurePoint> result = new List<MapMeasurePoint>();
                MeasureCollection collection = new MeasureCollection();

                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"SELECT bovenleiding.bovenleiding_id, bovenleiding.measurement_point_value, bovenleiding_gps.latitude, bovenleiding_gps.longitude, measurement_point_name, bovenleiding.rolling_stock_number " +
                                       "FROM bovenleiding " +
                                       "JOIN bovenleiding_gps ON bovenleiding_gps.date_time = bovenleiding.date_time " +
                                       "WHERE bovenleiding_gps.latitude BETWEEN -90 AND 90 " +
                                       "AND bovenleiding_gps.longitude BETWEEN -90 AND 90;";
                command.ExecuteNonQuery();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    int readNumber = 0;
                    while (reader.Read())
                    {
                        if (readNumber == 0)
                        {
                            collection.ID = reader.GetString(4);
                            collection.RailCode = reader.GetInt32(5) + "";
                            readNumber++;
                        }
                        result.Add(new MapMeasurePoint(reader.GetGuid(0), reader.GetDouble(1), reader.GetDouble(2), reader.GetDouble(3)));
                    }
                }
                collection.Maximum = result.Max(x => x.Value);
                collection.Minimum = result.Min(x => x.Value);
                collection.Average = result.Average(x => x.Value);
                collection.Content = result.ToArray();
                return collection;
            }
        }

        public static MeasurePoint GetMeasurePoint(Guid id)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"SELECT bovenleiding.bovenleiding_id, bovenleiding.measurement_point_value, bovenleiding_gps.latitude, bovenleiding_gps.longitude " +
                    $"FROM bovenleiding " +
                    $"JOIN bovenleiding_gps ON bovenleiding.date_time = bovenleiding_gps.date_time " +
                    $"WHERE bovenleiding.bovenleiding_id = '" + id + "';";
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        MeasurePoint returnObject = new MeasurePoint(id, reader.GetDouble(1), reader.GetDouble(2), reader.GetDouble(3));
                        return returnObject;
                    }
                    else
                    {
                        return new MeasurePoint();
                    }
                }
            }
        }

        public static string SafeGetString(this SqlDataReader reader, int colIndex)
        {
            if (!reader.IsDBNull(colIndex))
                return reader.GetString(colIndex);
            return string.Empty;
        }

        public static int SafeGetInt(this SqlDataReader reader, int colIndex)
        {
            if (!reader.IsDBNull(colIndex))
                return reader.GetInt32(colIndex);
            return 0;
        }

        public static int SafeGetInt16(this SqlDataReader reader, int colIndex)
        {
            if (!reader.IsDBNull(colIndex))
                return reader.GetInt16(colIndex);
            return 0;
        }

        public static RailObject GetRailobject( this SqlDataReader reader, string source)
        {
            Enum.TryParse(source, out Sources dataSource);
            switch (dataSource)
            {
                case Sources.SAP:
                    return new RailObject(
                        reader.SafeGetInt(SAP["equipment"]),
                        reader.GetGuid(SAP["secret-id"]).ToString(),
                        "ES-LAS",
                        reader.SafeGetString(SAP["description"]),
                        reader.SafeGetString(SAP["status"]),
                        reader.SafeGetString(SAP["user_status_equi"]),
                        reader.SafeGetString(SAP["parent_equi_kind"]),
                        reader.SafeGetString(SAP["datacollection"]),
                        reader.SafeGetString(SAP["placement"]),
                        reader.GetDouble(SAP["latitude"]),
                        reader.GetDouble(SAP["longitude"]),
                        "",
                        "",
                        "",
                        source,
                        reader.SafeGetInt16(SAP["year"]),
                        new string[] { });
                case Sources.SIGMA:
                    return new RailObject(
                        0,
                        reader.GetGuid(SIGMA["secret-id"]).ToString(),
                        "ES-LAS",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        reader.GetDouble(SIGMA["latitude"]),
                        reader.GetDouble(SIGMA["longitude"]),
                        "",
                        "",
                        "",
                        source,
                        reader.SafeGetInt16(SIGMA["year"]),
                        new string[] { });
                case Sources.UST02:
                    return new RailObject(
                        0,
                        reader.GetGuid(UST02["secret-id"]).ToString(),
                        "ES-LAS",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        reader.GetDouble(UST02["latitude"]),
                        reader.GetDouble(UST02["longitude"]),
                        reader.SafeGetString(UST02["pic_file_name"]),
                        reader.GetInt64(UST02["run_nr"]).ToString(),
                        reader.GetInt32(UST02["track_version"]).ToString(),
                        source,
                        reader.SafeGetInt16(UST02["year"]),
                        new string[] { });
                default:
                    return new RailObject();
            }
        }

        public static DateTime SafeGetDateTime(this SqlDataReader reader, int colIndex)
        {
            if (!reader.IsDBNull(colIndex))
                return reader.GetDateTime(colIndex);
            return DateTime.Now;
        }

        #region Authentication
        public static bool IsAuthorizedUser(string username, string password)
        { 
            using(SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();

                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"SELECT username FROM dbo.app_user WHERE username = '{username}' AND password = '{password}'";

                if ((string)command.ExecuteScalar() == username)
                    return true;
                else
                    return false;
            }
        }

        public static void CreateNewUserSession(string username, string token)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();

                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"INSERT INTO dbo.session (user_id, session_key, session_start) VALUES((SELECT user_id FROM dbo.app_user WHERE username = '{username}'), '{token}', CURRENT_TIMESTAMP)";

                command.ExecuteNonQuery();
            }
        }

        public static void RevokeUserSession(string username, string token)
        {
            using(SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();

                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"UPDATE dbo.session SET session_end = CURRENT_TIMESTAMP WHERE user_id = (SELECT user_id FROM dbo.app_user WHERE username = '{username}') && session_key = '{token}';";

                command.ExecuteNonQuery();
            }
        }

        public static Tuple<string, DateTime, DateTime> CheckToken(string username, string token)
        {
            using(SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();
                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"SELECT session_key, session_start, session_end FROM dbo.session JOIN dbo.app_user ON session.user_id = user.user_id WHERE username = '{username}', session_key = '{token}';";

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                        return new Tuple<string, DateTime, DateTime>(reader.GetString(0), reader.GetDateTime(1), reader.SafeGetDateTime(2));
                    else
                        return new Tuple<string, DateTime, DateTime>("NF", DateTime.Now, DateTime.Now);
                }
            }
        }

        public static bool RegisterUser(string email, string username, string password)
        {
            using (SqlConnection _connection = new SqlConnection(connectionString.ConnectionString))
            {
                _connection.Open();

                SqlCommand command = _connection.CreateCommand();
                command.CommandText = $"INSERT INTO dbo.user (email, username, password, created_date) VALUES ('{email}', '{username}', '{password}', CURRENT_TIMESTAMP);";

                if (command.ExecuteNonQuery() == 1)
                    return true;
                else
                    return false;
            }
        }
        #endregion
    }
}