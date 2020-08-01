using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.JSInterop;

namespace SIH_Dashboard
{
    public static class ConsoleHelper
    {
        public async static void Print(IJSRuntime Runtime, object val)
        {
            await Runtime.InvokeVoidAsync("print", val);
        }
    }
    public class DatabaseHelper
    {
        /// <summary>
        /// Set Data in DB
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="Runtime"></param>
        /// <param name="path">path follewed by / from root ref </param>
        /// <param name="data"></param>
        public async static void WriteData<T>(IJSRuntime Runtime, string path, T data)
        {
            await Runtime.InvokeVoidAsync("WriteData", path, data);
        }
        public async static Task<T> ReadData<T>(IJSRuntime Runtime, string path)
        {
            return await Runtime.InvokeAsync<T>("ReadData", path);
        }
        public async static void PushData<T>(IJSRuntime Runtime, string path, T data)
        {
            await Runtime.InvokeVoidAsync("PushData", path, data);
        }
        public async static Task<T> ReadList<T>(IJSRuntime Runtime, string path)
        {
            return await Runtime.InvokeAsync<T>("ReadList", path);
        }
        public async static Task<T> GetFeedbacks<T>(IJSRuntime Runtime, string path, int lmt = 0)
        {
            return await Runtime.InvokeAsync<T>("GetFeedbacks", path, lmt);
        }


    }
}
