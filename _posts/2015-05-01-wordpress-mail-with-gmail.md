---
id: 59
title: WordPress mail with Gmail
date: 2015-05-01T19:38:09+01:00
guid: http://svrooij.nl/?p=59
old_permalink: /2015/05/wordpress-mail-with-gmail/
twitter_image: /assets/images/2015/04/source_code1.png
categories:
  - Coding
tags:
  - gmail
  - wordpress
---

At some point you would like your wordpress website to be able to send email. You'll need it for:

  * Password recovery
  * `New User` notifications
  * Contact forms

<!--more-->

By putting this code in your `funtions.php` file off your <a href="https://codex.wordpress.org/Child_Themes" target="_blank">child-theme</a>, you won't need a plugin to configure the gmail settings.  

```php
add_action( 'phpmailer_init', 'gmail_phpmailer_init' );
function gmail_phpmailer_init( PHPMailer $phpmailer ) {
    $phpmailer->Host = 'smtp.gmail.com';
    $phpmailer->Port = 587; 
    $phpmailer->Username = 'pietje_puk@gmail.com'; // Full username (with @gmail.com)
    $phpmailer->Password = 'your_secret_password'; // Your own password
    $phpmailer->SMTPAuth = true; // Gmail requires authentication
    $phpmailer->SMTPSecure = 'tls'; //587 is the tls port, ssl can also be configured with 'ssl' and port  is another possible value

    $phpmailer->IsSMTP();
}
```

Without this code you also could use a plugin for the same thing, but who needs plugins 😛
