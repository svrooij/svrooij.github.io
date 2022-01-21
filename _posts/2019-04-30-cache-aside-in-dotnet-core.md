---
id: 249
title: Cache-aside in dotnet core
date: 2019-04-30T23:37:59+01:00


guid: https://svrooij.nl/?p=249
old_permalink: /2019/04/cache-aside-in-dotnet-core/
categories:
  - Coding
tags:
  - caching
  - dotnet
---
A really nice way to improve performance in any web application is to using caching. This is also true for dotnet core. The <a rel="noreferrer noopener" aria-label="Cache-aside (opens in a new tab)" href="https://docs.microsoft.com/nl-nl/azure/architecture/patterns/cache-aside" target="_blank">Cache-aside</a> pattern is a best described as. Let's check the cache if we got the required result, if we got this item cached return that. If we don't have it in cache, get it from the data store and save it for next time.

In dotnet core you can use both [Microsoft.Extentions.Caching.Memory](https://www.nuget.org/packages/Microsoft.Extensions.Caching.Memory/) or some [Distributed Cache](https://docs.microsoft.com/en-us/aspnet/core/performance/caching/distributed?view=aspnetcore-2.2). Choose either one because you're going to use it down the line.

<!--more-->

## Goals

* Must-be strong typed
* Able to set cache time for every item.
* As fast as possible
* Ability to pass a function to retrieve the item if it cannot be found in the cache
* In depended of caching technique

## Dependencies

While both methods are ways of caching stuff (either on the same server in memory or in a shared cache) they don't natively support the cache aside pattern. That's why I created my own caching aside library. First add the right packages. MessagePack is used to Serialize the Objects to a byte array (to be saved in the cache), because they claim to be the fastest library to do so. You can also you some other (de/)serializer if you want. I also choose to use Redis because it seams to be almost as fast as Memory Caching but has the advantage that it's distributed.

```posh
dotnet add package MessagePack
dotnet add package Microsoft.Extensions.Caching.Redis
dotnet add package Microsoft.Extensions.Logging
```

## Interface

```csharp
using System.Threading.Tasks;

public interface IStrongTypedCache
{
    Task<T> GetAsync<T>(string key) where T: class;
    Task<T> GetOrCacheAsync<T>(string key, Func<Task<T>> FetchFunction, TimeSpan cacheTime) where T : class;
    Task<string> GetStringAsync(string key);
    Task<string> GetOrCacheStringAsync(string key, Func<Task<string>> FetchFunction, TimeSpan cacheTime);
    Task RemoveAsync(string key);
}
```

## Implementation

```csharp
using System;
using System.Threading.Tasks;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Logging;

public class DistributedStrongTypedCache : IStrongTypedCache
{
    private readonly IDistributedCache _cache;
    private readonly ILogger _logger;
    public DistributedStrongTypedCache(IDistributedCache cache, ILogger<DistributedStrongTypedCache> logger){
        _cache = cache;
        _logger = logger;
    }
    public async Task<T> GetAsync<T>(string key) where T : class{
        _logger.LogDebug("Loading {Type} for key {key}", typeof(T).Name, key);
        var cachedValue = await _cache.GetAsync(key);
        if(cachedValue != null){
            _logger.LogInformation("Loaded {Type} for key {key}", typeof(T).Name, key);
            return MessagePack.MessagePackSerializer.Deserialize<T>(cachedValue, MessagePack.Resolvers.ContractlessStandardResolver.Instance);
        }
        return null;
    }
    public async Task<T> GetOrCacheAsync<T>(string key, Func<Task<T>> FetchFunction, TimeSpan cacheTime) where T : class
    {
        var cachedValue = await this.GetAsync<T>(key);
        if(cachedValue != null){
            return cachedValue;
        }
        _logger.LogDebug("Getting fresh {Type} for key {key}", typeof(T).Name, key);
        var valueToCache = await FetchFunction();
        if(valueToCache != null){
            await _cache.SetAsync(
                key,             MessagePack.MessagePackSerializer.Serialize(valueToCache, MessagePack.Resolvers.ContractlessStandardResolver.Instance),
                new DistributedCacheEntryOptions { AbsoluteExpirationRelativeToNow = cacheTime}
            );
            _logger.LogInformation("Saved fresh {Type} for key {key}", typeof(T).Name, key);
        }
        return valueToCache;
    }

    public async Task<string> GetStringAsync(string key){
        var cachedValue = await _cache.GetStringAsync(key);
        if(!string.IsNullOrEmpty(cachedValue))
            return cachedValue;
        return null;
    }

    public async Task<string> GetOrCacheStringAsync(string key, Func<Task<string>> FetchFunction, TimeSpan cacheTime)
    {
        var cachedValue = await _cache.GetStringAsync(key);
        if(!string.IsNullOrEmpty(cachedValue))
            return cachedValue;
        var valueToCache = await FetchFunction();

        if(!string.IsNullOrEmpty(valueToCache)){
            await _cache.SetStringAsync(
                key,valueToCache,
                new DistributedCacheEntryOptions { AbsoluteExpirationRelativeToNow = cacheTime}
            );
        }
        return valueToCache;
    }

    public Task RemoveAsync(string key)
    {
        return _cache.RemoveAsync(key);
    }
}
```

## Registration

```csharp
public class Startup
{
  public void ConfigureServices(IServiceCollection services)
  {
    // Register some IDistributedCache
    services.AddDistributedRedisCache(redis => {
      redis.Configuration = "localhost";
    });

    // Register the IStrongTypedCache
    services.AddTransient<Caching.IStrongTypedCache,Caching.DistributedStrongTypedCache>();
  }
}
```

## Usage

```csharp
var cachedItem = await cache.GetOrCacheAsync<MyClass>(
    "cache-key", // Use a hash of some kind of some other key
    () => { return Task.CompletedTask(new MyClass());}, // (async) function to get the value if it's cached.
    TimeSpan.FromHours(1) // Time to cache the item
);
```

This code is just a proof of concept, but if you guys like it, i'm happy to create a nuget for it. Let me know what you thing and what the library should contain.