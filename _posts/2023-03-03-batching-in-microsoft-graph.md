---
title: "Batching with Microsoft Graph"
published: true
categories:
  - Microsoft Graph
tags:
  - Microsoft Graph
  - Batching
twitter_image: /assets/images/2023/03/batch-add-users-to-group.png
---

Microsoft has this great [api](https://learn.microsoft.com/en-us/graph/overview) where you can control almost everything in the Microsoft 365 cloud. To speed up your requests, you can combine up to [20](#need-link) requests in a [batch](https://learn.microsoft.com/en-us/graph/json-batching). This post will explain how to use batching and how it got implemented in the [Graph SDK for DOTNET](https://github.com/microsoftgraph/msgraph-sdk-dotnet-core).

![Add users to group fast](/assets/images/2023/03/batch-add-users-to-group.png)

<!--more-->

## What is batching?

With [batching](https://learn.microsoft.com/en-us/graph/json-batching) you can combine multiple requests (to the same tenant and api version) in one http request. Each http request has a certain overhead. By combining requests you're able to send much more requests in the same time, and thus you're getting a higher throughput.

Our company [Roostersync](https://roostersync.nl), uses batching to put millions of events in users' their work calendar on a weekly basis. Batching really helps us getting a higher throughput, something that cannot be done without batching.

## No support for batching in the SDK

I've been a long time user of the Microsoft Graph API, and back in 2017 there was **beta** support for batching in the API, but not in the SDK for .net. So I created [this issue](https://github.com/microsoftgraph/msgraph-sdk-dotnet/issues/136) on June 4th 2017 to get it implemented.

![Timeframe](/assets/images/2023/03/gh-issue-graph-batching.png)

And eight months later, February 8th 2018, I had a great laugh for this [reaction](https://github.com/microsoftgraph/msgraph-sdk-dotnet/issues/136#issuecomment-364070540)

![Timeframe joke](/assets/images/2023/03/gh-issue-graph-batching-joke.png)

We where no longer waiting for it so we build our own in-house Graph client in 2018. We needed that speed improvement and waiting was no longer an option. Fast-forward to may 2019 (two years after I created the issue), they released batching support in the dotnet sdk. I must admit, we never used it until now, because our batch client was super fast and efficient already.

## Batching limit

When first introduced as a beta for Graph API, batching supported combining only `5` requests, which was lower than the `20` we where used to have at the old Outlook Rest API (which was the Graph api predecessor, back when they had an api for all services separately). I complained about this **A LOT**....

- June 5th 2017 [issue comment](https://github.com/microsoftgraph/msgraph-sdk-dotnet/issues/136#issuecomment-306253198)
- April 11th 2019 [docs Batch limit incorrect](https://github.com/microsoftgraph/microsoft-graph-docs/issues/4366#issue-431916349)
- July 3th 2019 [Stack overflow](https://stackoverflow.com/questions/56873802/microsoft-graph-api-batch-limit)
- June 17th 2020 [Limit was suddenly lowered](https://github.com/microsoftgraph/microsoft-graph-docs/issues/8760)

There was a batch limit for the Graph API which said to be 20, but was 15 in practice. And the limit was eventually lowered to 4 for outlook-based resources.

Fast forward to May 2022, after 2 years of being forced to combine less the ideal requests. I [created a pull request](https://github.com/microsoftgraph/microsoft-graph-docs/pull/17078) to update the documentation stating that there are special limits when talking to Outlook based resources. I also raised the issue with the Graph Developers with the help of some awesome people I met at a conference (thanks Yannick and Brian).

I'm not sure when they actually raised the batch limit for Outlook resources, but the [removed](https://github.com/microsoftgraph/microsoft-graph-docs/commit/4917797bc89889472ff002479266d31e9582376d) my section from the docs on september 28th 2022.

> Personal opinion: I still think the batch limit is to low, but at least it's back to 20 again.

## Hacktogether hackathon

[![Hack Together: Microsoft Graph and .NET](https://img.shields.io/badge/Microsoft%20-Hack--Together-orange?style=for-the-badge&logo=microsoft)](https://github.com/microsoft/hack-together)

Microsoft is hosting a [hackathon](https://github.com/microsoft/hack-together) around the Graph .net SDK, I took this opportunity to re-evaluate Batching in the Graph SDK, only to find out developers still have to manage the maximum amount of requests they combine in a single request. This tedious task should be improved (in my opinion).

My idea, I'll just extend the Graph SDK with some extension methods (which are great by the way) and take away this tedious task by providing a `BatchRequestContentCollection` that manages the amount of requests that may be combined in a single batch request (`20`) and splits the requests over multiple batches if needed, without throwing an error when the developer adds the twenty-first request. And my [Graph Batching extension](https://github.com/svrooij/msgraph-sdk-dotnet-batching/) was born, which is also my entry for the hack-a-thon.

Hours later I got a notification from Github about [this issue](https://github.com/microsoftgraph/msgraph-sdk-dotnet-core/issues/612), [Maísa Rissi](https://github.com/maisarissi) a Microsoft employee, seems to want this code integrated in the Graph SDK for DOTNET, and evaluate if the same principal could be used in other language SDKs as well. Ok, that was fast.

I skipped late night television to convert my extension library to a [pull request](https://github.com/microsoftgraph/msgraph-sdk-dotnet-core/pull/613) for the Graph SDK, let's see what happens from here. Any maybe somewhere in the near feature my batching code is integrated in the Graph SDK a lot of people are using. And if not, you can use it today by installing [this nuget package](https://www.nuget.org/packages/SvRooij.Graph.Batching/).

## Adding 400 users to a group

Let's say we have some variables to start with:

```csharp
var graphClient = new GraphServiceClient(...); // Use your preferred authentication method
var groupId = "712ff893-7bcb-48a5-8fe9-cf5c6adc21c6";
var users = new string[] {"b5c44dfd-d07f-40f3-b2b0-5f5ce6170196", "639c4885-679e-4aa4-beaf-e06d78d4dc96", "ad6969d4-7ee1-42c7-b1b7-fcf46206e737", ...}; // 400 user ids..
```

### Adding users without batching

Without batching you would add those to that group with this code:

```csharp
foreach(var userId in users)
{
    var requestBody = new Microsoft.Graph.Models.ReferenceCreate { OdataId = $"https://graph.microsoft.com/v1.0/directoryObjects/{userId}" };
    await graphClient.Groups[groupId].Members.Ref.PostAsync(requestBody);
}
```

The code above results in 1 http call for each user.

### Adding users with batching (exception)

Lets combine this into a batch.

```csharp
var batchRequestContent = new BatchRequestContent(graphClient);
foreach(var userId in users)
{
    var requestBody = new Microsoft.Graph.Models.ReferenceCreate { OdataId = $"https://graph.microsoft.com/v1.0/directoryObjects/{userId}" };
    await batchRequestContent.AddBatchRequestStepAsync(graphClient.Groups[groupId].Members.Ref.ToPostRequestInformation(requestBody)); 
}
var batchResponse = await graphClient.Batch.PostAsync(batchRequestContent);
```

This code will throw an exception even before sending 1 byte of data to Graph, the `BatchRequestContent` will [throw an exception](https://github.com/microsoftgraph/msgraph-sdk-dotnet-core/blob/1f6cffe19664d3093917a577a1f807469838162f/src/Microsoft.Graph.Core/Requests/Content/BatchRequestContent.cs#L122-L125) when your foreach loop reached user 21.

### Adding users with batching

My `BatchRequestContentCollection` to the rescue.

```csharp
var batchCollection = new BatchRequestContentCollection(graphClient);
foreach(var userId in users)
{
    var requestBody = new Microsoft.Graph.Models.ReferenceCreate { OdataId = $"https://graph.microsoft.com/v1.0/directoryObjects/{userId}" };
    await batchCollection.AddBatchRequestStepAsync(graphClient.Groups[groupId].Members.Ref.ToPostRequestInformation(requestBody)); 
}
var responseCollection = await graphClient.Batch.PostAsync(batchCollection);
```

This code will result in 1 http call per 20 users you want to add to the group.

### Adding multiple users to a group

You think that is the fastest you can go?
How about combining [add multiple users in one request](https://learn.microsoft.com/en-us/graph/api/group-post-members?view=graph-rest-1.0&tabs=csharp#request-1) with batching?

This code is untested, but I guess the following code would allow you to add 400 users to a single group in a single http call. My development tenant is to small to test this out, please let me know if it works?
The value for `"members@odata.bind"` has to be the same api as the client. So if you use the beta endpoint, you should change the reference as well.

```csharp
var batchCollection = new BatchRequestContentCollection(graphClient);

int index = 0;
do {
    // You can only combine adding 20 users in a single patch request (don't ask me how I know).
    // And I know this could can be made easier, just cannot find the code at this moment.
    var usersToAdd = users.Skip(index * 20).Take(20);
    var requestBody = new Group
    {
        AdditionalData = new Dictionary<string, object>
        {
            {
                "members@odata.bind" , usersToAdd.Select(id => $"https://graph.microsoft.com/v1.0/directoryObjects/{id}")
            },
        },
    };
    await batchCollection.AddBatchRequestStepAsync(graphClient.Groups[groupId].ToPatchRequestInformation(requestBody));
} while(users.Length > (index * 20));

var responseCollection = await graphClient.Batch.PostAsync(batchCollection);
```

## Connect with me

[![LinkedIn Profile][badge_linkedin]][link_linkedin]
[![Link Mastodon][badge_mastodon]][link_mastodon]
[![Follow on Twitter][badge_twitter]][link_twitter]
[![My MVP profile][badge_mvp]][link_mvp-profile]
[![Check my blog][badge_blog]][link_blog]

[badge_blog]: https://img.shields.io/badge/blog-svrooij.io-blue?style=for-the-badge
[badge_linkedin]: https://img.shields.io/badge/LinkedIn-stephanvanrooij-blue?style=for-the-badge&logo=linkedin
[badge_mastodon]: https://img.shields.io/mastodon/follow/109502876771613420?domain=https%3A%2F%2Fdotnet.social&label=%40svrooij%40dotnet.social&logo=mastodon&logoColor=white&style=for-the-badge
[badge_mvp]: https://img.shields.io/badge/MVP-Security-blue?style=for-the-badge&logo=microsoft
[badge_twitter]: https://img.shields.io/twitter/follow/svrooij?logo=twitter&style=for-the-badge&logoColor=white
[link_blog]: https://svrooij.io/
[link_linkedin]: https://www.linkedin.com/in/stephanvanrooij
[link_mastodon]: https://dotnet.social/@svrooij
[link_mvp-profile]: https://mvp.microsoft.com/en-us/PublicProfile/5004985
[link_twitter]: https://twitter.com/svrooij
