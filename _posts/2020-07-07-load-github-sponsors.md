---
title: "Query github sponsors with graphql"
published: true
tags:
  - Github
  - Github Sponsors
---

Github exposes all their data at a [GraphQL endpoint](https://developer.github.com/v4/), that you can also try out with the [Github GraphQL explorer](https://developer.github.com/v4/explorer/).

If you want to query who is sponsoring you, use the following GraphQL. You can use this query at the explorer of in your own graphql client.

```graphql
{
  viewer {
    login
    sponsorshipsAsMaintainer(first: 100, orderBy: {field: CREATED_AT, direction: ASC}, includePrivate: true) {
      totalCount
      pageInfo {
        endCursor
      }
      nodes {
        sponsorEntity {
          ... on User {
            name
            login
            url
          }
          ... on Organization {
            name
            url
            login
          }
        }
        createdAt
        privacyLevel
        tier {
          monthlyPriceInCents
        }
      }
    }
  }
}
```

## Ideas

1. Build a website where a higher sponsor tier unlocks more features
2. Include your sponsors in a `README.md` file for some repository.

Both ideas intrige me, so if you have some code that could help with that, please let me know.