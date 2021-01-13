---
title: "Azure Functions serve static files"
published: true
tags:
  - Azure Functions
  - Static files
image: /assets/images/azure-functions-angular-love.png
---

Azure functions are great to quickly create an API. But did you know you can also host static files with it? Anthony Chu made a [great post](https://anthonychu.ca/post/azure-functions-static-file-server/) about hosting static files in Azure Functions. His code is from March 9, 2017 however, and can be improved in the mean time.

## Why host static files with Azure Functions

Some would ask, why would you want to host static files from an Azure Functions app, which is a good question since there are other ways to do just that. Using an Azure Functions app to host static files has the following adventages:

- Keeping your code in one app.
- Support for custom domains (with SNI SSL).
- Only one deploy
- Probably free (1.000.000 executions per month)

## Static file server function

Since it's still hosted in Azure Functions you'll need a function to server the specific files. The following function servers all the files from the `www` folder in your functions app by specifing it's filename as a query parameter. `/api/ServeStaticFile?file=index.html`. Make sure the files you want to serve are marked as `content`. Add the [MimeTypeMapOfficial package](https://www.nuget.org/packages/MimeTypeMapOfficial) to get `using MimeTypes;` working.

```csharp
using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using MimeTypes;
using Microsoft.Extensions.Configuration;

namespace AzureFunctions.StaticFiles
{
    public class ServeStaticFile
    {   
        private readonly string contentRoot;
        // This key is used by Azure Functions to tell you what is the root of this website.
        private const string ConfigurationKeyApplicationRoot = "AzureWebJobsScriptRoot";
        private const string staticFilesFolder = "www";
        private readonly string defaultPage;
        // The configuration is available for injection.
        // The used settings can be in any config (environment, host.json local.settings.json)
        public ServeStaticFile(IConfiguration configuration)
        {
            this.contentRoot = Path.GetFullPath(Path.Combine(
              configuration.GetValue<string>(ConfigurationKeyApplicationRoot),
              staticFilesFolder));
            this.defaultPage = configuration.GetValue<string>("DEFAULT_PAGE", "index.html");
        }

        [FunctionName("ServeStaticFile")]
        public async Task<IActionResult> Run(
          [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req,ILogger log)
        {
            try
            {
                var filePath = GetFilePath(req.Query["file"]);
                if (File.Exists(filePath))
                {
                    var stream = File.OpenRead(filePath);
                    return new FileStreamResult(stream, GetMimeType(filePath))
                    {
                        LastModified = File.GetLastWriteTime(filePath)
                    };
                } else
                {
                    return new NotFoundResult();
                }
            }
            catch
            {
                return new BadRequestResult();
            }
        }

        private string GetFilePath(string pathValue)
        {
            var path = pathValue ?? "";
            string fullPath = Path.GetFullPath(Path.Combine(contentRoot, pathValue));
            if (!IsInDirectory(this.contentRoot, fullPath))
            {
                throw new ArgumentException("Invalid path");
            }

            if (Directory.Exists(fullPath))
            {
                fullPath = Path.Combine(fullPath, defaultPage);
            }
            return fullPath;
        }

        private static bool IsInDirectory(string parentPath, string childPath) => childPath.StartsWith(parentPath);
        
        private static string GetMimeType(string filePath)
        {
            var fileInfo = new FileInfo(filePath);
            return MimeTypeMap.GetMimeType(fileInfo.Extension);
        }
    }
}

```

## Using a proxy for nice urls

Having a function that serves a file is one thing, but you probably want to call `/app/style.css` instead of `/api/ServeStaticFile?file=style.css`. This can be accomplished with the [Azure functions proxies](https://docs.microsoft.com/en-us/azure/azure-functions/functions-proxies) feature.

Create a `proxies.json` file in the root of your functions project, with the following content and reboot your functions app.

```json
{
  "$schema": "http://json.schemastore.org/proxies",
  "proxies": {
    "redirect-to-app": {
      "disabled": false,
      "matchCondition": {
        "methods": [ "GET" ],
        "route": "/"
      },
      "responseOverrides": {
        "response.statusCode": "302",
        "response.headers.Location": "/app/"
      }
    },
    "app": {
      "disabled": false,
      "matchCondition": {
        "methods": [ "GET", "OPTIONS" ],
        "route": "/app/{*path}"
      },
      "backendUri": "https://localhost/api/ServeStaticFile?file={path}",
      "responseOverrides": {
        "response.headers.Cache-Control": "public,max-age=600"
      }
    }
  }
}
```

Your function app output should display 2 extra functions with http triggers. One to redirect `/` to `/app/` and one to proxy requests to `/app/*` to `/api/ServiceStaticFile?file={the_rest_of_the_path}`. This last one also sets a cache header, but any header could be changed at this moment.

This would mean that any static content is only served from the subdirectory `/app`, I couldn't get it to work from the root url, because that would make all the http endpoints (starting with `/api`) inaccessible.

## Serve angular from dev server during development

My usecase was that I wanted to eventually run an angular application (so SPA with functions api) all from within a single Functions app. (This resembles Azure Static Web App, but I can deploy it in the way I want without being forced to use Github Actions).

To do this during development you should do three things:

- Add the baseHref `/app/` to the **angular.json** file. Located at key: `projects -> your-project -> architect -> build -> baseHref`
- Change the proxy file to proxy to the local dex server
- Start the angular dev server `npx ng serve --no-live-reload` (in a seperate terminal window).

```json
{
  "$schema": "http://json.schemastore.org/proxies",
  "proxies": {
    "redirect-to-app": {
      "disabled": false,
      "matchCondition": {
        "methods": [ "GET" ],
        "route": "/"
      },
      "responseOverrides": {
        "response.statusCode": "302",
        "response.headers.Location": "/app/"
      }
    },
    "app": {
      "disabled": true,
      "matchCondition": {
        "methods": [ "GET", "OPTIONS" ],
        "route": "/app/{*path}"
      },
      "backendUri": "https://localhost/api/ServeStaticFile?file={path}",
      "responseOverrides": {
        "response.headers.Cache-Control": "public,max-age=600"
      }
    },
    "dev-app-root": {
      "disabled": false,
      "matchCondition": {
        "methods": [ "GET" ],
        "route": "/app/"
      },
      "backendUri": "http://127.0.0.1:4200/app/"
    },
    "dev-app-files": {
      "disabled": false,
      "matchCondition": {
        "methods": [ "GET" ],
        "route": "/app/{*path}"
      },
      "backendUri": "http://127.0.0.1:4200/app/{path}"
    }
  }
}
```

