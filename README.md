Overview
========
mailR allows users to send emails from R.

It is developed as a wrapper around [Apache Commons Email](http://commons.apache.org/proper/commons-email/) and offers several features to send emails from R such as:
- using authentication-based SMTP servers
- sending emails to multiple recipients (including the use of Cc, Bcc, and ReplyTo recipients)
- attaching multiple files from the file system or from URLs
- sending HTML formatted emails with inline images

What's new in version 0.5
-------------------------
**6th December 2016**

*Enhancements*
- Better handling of errors thrown by Java (thanks to @chlorenz)
- Email clients unable to view HTML emails now receive stripped down version of message (Fixes #24)

Installation instructions
=========================
You can install the latest development version of mailR using devtools:

```R
install.packages("devtools", dep = T)
library(devtools)
install_github("rpremraj/mailR")

library(mailR)
```

The latest release of mailR is available on [CRAN](http://cran.r-project.org/web/packages/mailR/):

```R
install.packages("mailR", dep = T)

library(mailR)
```

Usage
=====
To send an email via a SMTP server that does not require authentication:

```R
send.mail(from = "sender@gmail.com",
          to = c("Recipient 1 <recipient1@gmail.com>", "recipient2@gmail.com"),
          cc = c("CC Recipient <cc.recipient@gmail.com>"),
          bcc = c("BCC Recipient <bcc.recipient@gmail.com>"),
          subject = "Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "aspmx.l.google.com", port = 25),
          authenticate = FALSE,
          send = TRUE)
```

*Note that aspmx.l.google.com works for gmail recipients only. Check your gmail spam folder if using this server.*

To send an email via a SMTP server that requires authentication:

```R
send.mail(from = "sender@gmail.com",
          to = c("recipient1@gmail.com", "Recipient 2 <recipient2@gmail.com>"),
          replyTo = c("Reply to someone else <someone.else@gmail.com>")
          subject = "Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)
```

To send an email with utf-8 or other encoding:

```R
email <- send.mail(from = "Sender Name <sender@gmail.com>",
                   to = "recipient@gmail.com",
                   subject = "A quote from Gandhi",
                   body = "In Hindi :  थोडा सा अभ्यास बहुत सारे उपदेशों से बेहतर है।
                   English translation: An ounce of practice is worth more than tons of preaching.",
                   encoding = "utf-8",
                   smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = T),
  			   authenticate = TRUE,
				   send = TRUE)
```           
           
To send an email with one or more file attachments, and set the debug parameter to see a detailed log message:

```R
send.mail(from = "sender@gmail.com",
          to = c("recipient1@gmail.com", "recipient2@gmail.com"),
          subject = "Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE,
          attach.files = c("./download.log", "upload.log", "https://dl.dropboxusercontent.com/u/5031586/How%20to%20use%20the%20Public%20folder.rtf"),
          file.names = c("Download log.log", "Upload log.log", "DropBox File.rtf"), # optional parameter
          file.descriptions = c("Description for download log", "Description for upload log", "DropBox File"), # optional parameter
          debug = TRUE)
```

To send a HTML formatted email:

```R
send.mail(from = "sender@gmail.com",
          to = c("recipient1@gmail.com", "recipient2@gmail.com"),
          subject = "Subject of the email",
          body = "<html>The apache logo - <img src=\"http://www.apache.org/images/asf_logo_wide.gif\"></html>", # can also point to local file (see next example)
          html = TRUE,
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)
```

To send a HTML formatted email with embedded inline images:

```R
send.mail(from = "sender@gmail.com",
          to = c("recipient1@gmail.com", "recipient2@gmail.com"),
          subject = "Subject of the email",
          body = "path.to.local.html.file",
          html = TRUE,
          inline = TRUE,
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)
```
*send.mail expects the images in the HTML file to be referenced relative to the current working directory (something to improve upon in the future).*

MS Exchange server
==================
Two mailR users confirmed being able to send emails via Exchange using the following code:
```R
send.mail(from = from,
          to = to,
          subject = subject,
          body = msg, 
          authenticate = TRUE,
          smtp = list(host.name = "smtp.office365.com", port = 587,
                      user.name = "xxx@domain.com", passwd = "xxx", tls = TRUE))
```

Sending HTML files compiled using Markdown
==========================================
mailR does not currently support resolving inline images encoded using the [data URI scheme](http://en.wikipedia.org/wiki/Data_URI_scheme). Use the workaround below instead:

First off, create the HTML file from the R terminal (the important thing here is that options does not include "base64_images" --- see `?markdown::markdownHTMLOptions`):
```R
library(knitr)
knit2html("my_report.Rmd", options = "")
```

Now you can send the resulting HTML file via mailR:
```R
send.mail(from = "sender@gmail.com",
          to = c("recipient1@gmail.com", "recipient2@gmail.com"),
          subject = "HTML file generated using Markdown",
          body = "my_report.html",
          html = TRUE,
          inline = TRUE,
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)
```

Issues/Contibutions
===================
Happy to hear about issues you encounter using mailR via Github's [issue tracker](https://github.com/rpremraj/mailR/issues/new).

Change log
===================
**30th December 2014**

*Features*
- Attach files to the email using URLs, e.g., you can send files from your Dropbox public folder using the URL.
- A 'debug' parameter to set that will make send.mail() provide a detailed log.
- Option to set a email address to reply to using the 'replyTo' parameter.

*Enhancement*
- Upgraded Commons Email Jar to version 1.3.3
- Upgraded Javax.mail Jar to version 1.5.2

**08th September 2014**

*Enhancement*
- Better resolution of paths to allow attaching files from locations other than the working directory.
- Updated documentation to give example of use on MS Exchange

**12th May 2014**

*Features*
- Added support to encode emails using iso-8859-1, utf-8, us-ascii, and koi8-r character sets.
- The body parameter can point to a locally stored text (or HTML) file and mailR will parse its contents to create the body of the email.

*Bug fixes*
- Experimental: changed called methods to set SSL/TLS to true to check whether it resolves issue that causes port number to default to 465.

**20th April 2014**

*Features*
- mailR now allows sending email content as HTML including allowing for embedding images as inline (currently an experimental feature).
- Email addresses conforming to RFC 2822 allowed, e.g., "FirstName LastName <sender@domain.com>" allowed.
- A java stacktrace is printed out in case of failure when sending the email to allow better root cause analysis.

*Bug fixes*
- Fixed a bug that incorrectly set the TLS parameter as TRUE whenever the SSL parameter was set as TRUE.
