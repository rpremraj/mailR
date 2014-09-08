Overview
========
mailR allows users to send emails from R via an accessible SMTP server.

It is developed as a wrapper around [Apache Commons Email](http://commons.apache.org/proper/commons-email/) and offers several desirable features to send mails from R:
- use authentication-based SMTP servers
- send emails to multiple recipients (including the use of Cc and Bcc recipients)
- attach multiple files to the email
- send HTML formatted emails with inline images

What's new
----------
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
- Email addresses conforming to RFC 2822 allowed, e.g., "FirstName LastName \<sender@domain.com\>" allowed.
- A java stacktrace is printed out in case of failure when sending the email to allow better root cause analysis.

*Bug fixes*
- Fixed a bug that incorrectly set the TLS parameter as TRUE whenever the SSL parameter was set as TRUE.

Sample use cases
=================

1. Create a workflow to generate business/status reports and have them delivered to you by email using *an authorized SMTP server* (a critical requirement when dealing with sensitive data).

2. Periodically send updates on the status of long-running R processes. This is especially helpful when process running on remote machines encounter an error.

3. Keep your entire team on the same page on the progress of the R process by being able to deliver mails to multiple recipients.

Installation instructions
=========================
You can install the latest development version of mailR using devtools:

```R
install.packages("devtools", dep = T)
library(devtools)
install_github("mailR", "rpremraj")

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
          subject="Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "aspmx.l.google.com", port = 25),
          authenticate = FALSE,
          send = TRUE)
```
*Note that the SMTP server aspmx.l.google.com only works for gmail recipients. Do check your gmail spam folder in case you are testing using this SMTP server.*

To send an email via a SMTP server that requires authentication:

```R
send.mail(from = "sender@gmail.com",
          to = c("recipient1@gmail.com", "recipient2@gmail.com"),
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
           
To send an email with one or more file attachments:

```R
send.mail(from = "sender@gmail.com",
          to = c("recipient1@gmail.com", "recipient2@gmail.com"),
          subject = "Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE,
          attach.files = c("./download.log", "upload.log"),
          file.names = c("Download log", "Upload log"), # optional parameter
          file.descriptions = c("Description for download log", "Description for upload log"))
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
Two mailR confirmed being able to use mailR via Exchange. While one user's environment didn't need authentication, the other user used the following code:
```R
send.mail(from = from,
          to = to,
          subject = subject,
          body = msg, 
          authenticate = TRUE,
          smtp = list(host.name = "smtp.office365.com", port = 587,
                      user.name = "xxx@domain.com", passwd = "xxx", tls = TRUE))
```

Issues/Contibutions
===================
Happy to hear about any issues you encounter using mailR. Simply [file a ticket](https://github.com/rpremraj/mailR/issues/new) on github or <A HREF="&#109;&#97;&#105;&#108;&#116;&#111;&#58;%72%2E%70%72%65%6D%72%61%6A%2B%6D%61%69%6C%52%40%67%6D%61%69%6C%2E%63%6F%6D">email me</A>. Pathes welcome ;-)
