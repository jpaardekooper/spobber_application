using System;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Linq;
using System.Web;
using System.Timers;
using Microsoft.Win32.SafeHandles;
using System.Runtime.InteropServices;

namespace SpobberApi.Statics
{
    public static class Users
    {
        private static ConcurrentBag<User> _users = new ConcurrentBag<User>();

        private static bool _timerStarted = false;
        private static Timer _timer = new Timer(300000.0);

        public static void RefreshUser(string username, string token)
        {
            if (!_timerStarted)
            {
                _timer.Start();
                _timer.Elapsed += CheckUsers;
            }
            lock (_users)
            {
                if (_users.Any(x => x.Username == username && x.Token == token))
                    _users.First(x => x.Username == username && x.Token == token).LastUpdate = DateTime.Now;
            }
        }

        public static bool CheckToken(string username, string token)
        {
            lock (_users)
            {
                return _users.Any(x => x.Username == username && x.Token == token);
            }
        }

        public static string AddUser(string username)
        {
            lock (_users)
            {
                User newUser = new User(username);
                _users.Add(newUser);
                return newUser.Token;
            }
        }

        private static void CheckUsers(object source, ElapsedEventArgs e)
        {
            lock (_users)
            {
                foreach (User user in _users.Where(x => DateTime.Now - x.LastUpdate > TimeSpan.FromMinutes(5)))
                {
                    user.Dispose();
                    DatabaseManager.RevokeUserSession(user.Username);
                }
            }
        }
    }

    class User : IDisposable
    {
        public string Username { get; private set; }
        public string Token { get; private set; }

        public DateTime LastUpdate { get; set; }

        bool disposed = false;
        SafeHandle handle = new SafeFileHandle(IntPtr.Zero, true);

        public User(string username)
        {
            Username = username;
            Token = Convert.ToBase64String(Guid.NewGuid().ToByteArray());
            LastUpdate = DateTime.Now;

            DatabaseManager.CreateNewUserSession(username, Token);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposed)
                return;

            if (disposing)
            {
                handle.Dispose();
            }

            disposed = true;
        }
    }
}