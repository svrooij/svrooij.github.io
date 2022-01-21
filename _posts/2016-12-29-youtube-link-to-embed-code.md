---
id: 114
title: Youtube link to Embed code
date: 2016-12-29T01:04:50+01:00


guid: https://svrooij.nl/?p=114
old_permalink: /2016/12/youtube-link-to-embed-code/
twitter_image: /assets/images/2015/04/source_code1.png
categories:
  - Coding
tags:
  - embed
  - regular expressions
  - youtube
---
Allowing users of your website to include a video into a message, can be done in two ways.

1. You instruct all the users to go to the video page, find the embed code, let them upload html to your website and displaying the raw html to all users.
2. You tell them to paste the link to the youtube page, and your website generates the embed code right from that link.

<!--more-->

While the first option seams like the easiest one (for you as a programmer), it might also be a bad choice in user-friendliness and security wise it isn't very smart to allow the user to upload html (especially iframes).

The second option, allowing just pasting the link, would seem like a lot of work. But it is actually quitte easy.

```csharp
using System.Text.RegularExpressions;
namespace YourNamespace
{
    internal static class StringExtensions
    {
        //http://stackoverflow.com/questions/3652046/c-sharp-regex-to-get-video-id-from-youtube-and-vimeo-by-url
        static readonly Regex YoutubeVideoRegex = new Regex(@"youtu(?:\.be|be\.com)/(?:(.*)v(/|=)|(.*/)?)([a-zA-Z0-9-_]+)", RegexOptions.IgnoreCase);
        static readonly Regex VimeoVideoRegex = new Regex(@"vimeo\.com/(?:.*#|.*/videos/)?([0-9]+)", RegexOptions.IgnoreCase | RegexOptions.Multiline);

        // Use as
        // string youtubeLink = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
        // var embedCode = youtubeLink.UrlToEmbedCode();
        static internal string UrlToEmbedCode(this string url)
        {
            if (!string.IsNullOrEmpty(url))
            {
                var youtubeMatch = YoutubeVideoRegex.Match(url);
                if (youtubeMatch.Success)
                {
                    return getYoutubeEmbedCode(youtubeMatch.Groups[youtubeMatch.Groups.Count - 1].Value);
                }

                var vimeoMatch = VimeoVideoRegex.Match(url);
                if (vimeoMatch.Success)
                {
                    return getVimeoEmbedCode(vimeoMatch.Groups[1].Value);
                }
            }
            return null;
        }

        const string youtubeEmbedFormat = "&lt;iframe type="\&quot;text/html\&quot;" class="\&quot;embed-responsive-item\&quot;" src="\&quot;https://www.youtube.com/embed/{0}\&quot;"&gt;&lt;/iframe&gt;";
        private static string getYoutubeEmbedCode(string youtubeId)
        {
            return string.Format(youtubeEmbedFormat, youtubeId);
        }

        const string vimeoEmbedFormat = "&lt;iframe src="\&quot;https://player.vimeo.com/video/{0}\&quot;" class="\&quot;embed-responsive-item\&quot;" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""&gt;&lt;/iframe&gt;";
        private static string getVimeoEmbedCode(string vimeoId)
        {
            return string.Format(vimeoEmbedFormat, vimeoId);
        }
    }
}
```
