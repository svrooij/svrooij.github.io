---
title: Cancellable task with timeout
categories:
  - Development
tags:
  - Code snippet
  - C#
twitter_image: /assets/images/2022/10/linked-cancellation-token.png
---

Don't you like the `async` and `await` way of asynchronously programming in C#? I can tell you I like them a lot. Recently I came across a case where I wanted to add a timeout to an asynchronous task.

<!--more-->

## Original code

To make the entire code cancellable it's important to propagate the original `CancellationToken`, that allows the application calling this method to cancel **all** the asynchronous work. So if you're doing for instance http calls inside this method, pass the main cancellationToken to all requests inside your method. In synchronous work, like a loop for instance, you can check if you should continue by checking `cancallationToken.IsCancellationRequested`.

```csharp
public async Task<int> ModifyItems(string user, IEnumerable<SomeItem> items, CancellationToken cancellationToken) {
  int itemsModified = 0;
  var random = new Random();
  int delay = random.Next(2000, 4000);
  // Do the work, just a delay of 2000 to 4000 milliseconds at the moment.
  // We propagate the cancellation token to make the delay itself cancellable.
  await Task.Delay(delay, cancellationToken);
  itemsModified = random.Next(items.Count());
  return itemsModified;
}
```

## Introduce a CancellationTokenSource

You can create a `CancellationTokenSource` to introduce a specific timeout, so we try using that instead.

```csharp
public async Task<int> ModifyItems(string user, IEnumerable<SomeItem> items, CancellationToken cancellationToken) {
  int itemsModified = 0;

  // New CancellationTokenSource that will fire after 3000 milliseconds, disposing them is important hence the using.
  using var timeoutCancellationSource = new CancellationTokenSource(3000);
  var random = new Random();
  int delay = random.Next(2000, 4000);
  // Do the work, just a delay of 2000 to 4000 milliseconds at the moment.
  // We no longer propagate the original CancellationToken.
  // This task is no longer cancellable, it will only listen for the timeout.
  await Task.Delay(delay, timeoutCancellationSource.Token);
  itemsModified = random.Next(items.Count());
  return itemsModified;
}
```

## Combine two CancellationTokens

In the previous solution we've seen a way to create a new CancellationToken that fires after a specific timeout, but the downside is that we no longer listen to the main CancellationToken. What if there was a way to combine the two CancellationTokens to a new CancellationToken that listens to either the main cancellation or the timeout.

```csharp
public async Task<int> ModifyItems(string user, IEnumerable<SomeItem> items, CancellationToken cancellationToken) {
  int itemsModified = 0;
  // CancellationTokenSource that will fire after 3000 milliseconds.
  using var timeoutCancellation = new CancellationTokenSource(3000);

  // Create a "LinkedTokenSource" combining two CancellationTokens into one.
  using var combinedCancellation = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken, timeoutCancellation.Token);

  var random = new Random();
  int delay = random.Next(2000, 4000);
  // Do the work, just a delay of 2000 to 4000 milliseconds at the moment.
  // This Task will cancel after a 3000 milliseconds timeout or when the main cancellation is called.
  await Task.Delay(delay, combinedCancellation.Token);

  itemsModified = random.Next(items.Count());
  return itemsModified;
}
```
