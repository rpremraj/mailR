Overview
========
mailR allows users to send emails from within R via an accessible SMTP server.

It is developed as a wrapper around [Apache Commons Email](http://commons.apache.org/proper/commons-email/) and offers a majority of the project's functionality. mailR offers several additional features in contrast to other similar R packages, namely [mail](http://cran.r-project.org/web/packages/mail/) and [sendmail](http://cran.r-project.org/web/packages/sendmailR/). It allows users to:
- use authentication-based SMTP servers
- send emails to multiple recipients (including the use of Cc and Bcc)
- attach multiple files from the file system to the email.
- *[NEW]* send HTML formatted emails with inline images.

New Features (as of 20-04-2014)
------------
- mailR now allows sending email content as HTML including allowing for embedding images as inline (currently an experimental feature).
- Email addresses conforming to RFC 2822 allowed, e.g., "FirstName LastName \<sender@domain.com\>" allowed.
- A java stacktrace is printed out in case of failure when sending the email to allow better root cause analysis.

Bug fixes (as of 20-04-2014)
---------
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
I do not have access to an exchange server, so I cannot test mailR against it. Would be great to get a short note if you could successfully use mailR via MS Exchange. Thanks! 


Issues/Contibutions
===================
Happy to hear about any issues you encounter using mailR. Simply file a ticket on github or feel free to <A HREF="&#109;&#97;&#105;&#108;&#116;&#111;&#58;%72%2E%70%72%65%6D%72%61%6A%2B%6D%61%69%6C%52%40%67%6D%61%69%6C%2E%63%6F%6D">email me</A>, or even send in a patch ;-)

Also, would be great to have collaborators to further extend the functionality of mailR.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/1650fb9891b70b7440cc380824b513f0 "githalytics.com")](http://githalytics.com/rpremraj/mailR)
