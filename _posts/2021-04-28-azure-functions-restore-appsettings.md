---
title: "Azure Functions restore app settings"
published: true
tags:
  - Azure Functions
  - App settings
image: /assets/images/azure-functions-json.png
---

Azure Functions share a lot with ASP.NET core, but some really usefull things aren't supported by default. I was missing the [configuration stuff](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/) when building an Azure Functions app.

## What is missing

ASP.NET core loads a few configuration sources by default, and they are really usefull.

- `appsettings.json` the **default** configuration file
- `appsettings.{environment}.json` the environment specific config file.
- Some other providers (see above link)

Azure functions does look for an `appsettings.json` but that is the one in the Azure Functions runtime folder. So lets restore the aps.net core configuration functionallity.

## 1. Nuget package

First you'll need an extra nuget package `Microsoft.Azure.Functions.Extensions`, so go ahead and install it.

## 2. Startup file

Create a special Azure Functions startup file (if you haven't already).

```csharp
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;

[assembly: FunctionsStartup(typeof(YourNamespace.Startup))]
namespace YourNamespace
{
  public class Startup : FunctionsStartup
  {
    public override void ConfigureAppConfiguration(IFunctionsConfigurationBuilder builder)
    {
      // Set filenames, adjust accoringly
        string basePath = Startup.IsDevelopmentEnvironment() ?
          Environment.GetEnvironmentVariable("AzureWebJobsScriptRoot") :
          $"{Environment.GetEnvironmentVariable("HOME")}\\site\\wwwroot";
        var baseSettings = System.IO.Path.Combine(basePath, "appsettings.json");
        var envSettings = System.IO.Path.Combine(basePath, $"appsettings.{Environment.GetEnvironmentVariable("AZURE_FUNCTIONS_ENVIRONMENT")}.json");

        // Add the configuration providers.
        builder.ConfigurationBuilder
            .AddJsonFile(baseSettings, optional: true, reloadOnChange: false)
            .AddJsonFile(envSettings, optional: true, reloadOnChange: false);
    }

    public override void Configure(IFunctionsHostBuilder builder)
    {
      // This has to be here, but we don't add any services
    }

    private static bool IsDevelopmentEnvironment()
    {
      // This variable is set by the Azure Functions runtime, you can also use your own logic.
      return "Development".Equals(Environment.GetEnvironmentVariable("AZURE_FUNCTIONS_ENVIRONMENT"), StringComparison.OrdinalIgnoreCase);
    }
  }
}
```

## 3. Add the settings file(s)

You are now ready to add the `appsettings.json` file and optionally the `appsettings.yourenvironment.json` files. Be sure to mark them as **Copy always** or **Copy if newer**.
