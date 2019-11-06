using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Models.Authentication
{
    public class ReturnToken
    {
        public string Username { get; private set; }
        public string Token { get; private set; }

        public ReturnToken(string username, string token)
        {
            Username = username;
            Token = token;
        }
    }
}