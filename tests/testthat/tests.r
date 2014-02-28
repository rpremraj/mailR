email <- send.mail(from = "sender@gmail.com",
                   to = c("recipient1@gmail.com", "recipient2@gmail.com"),
                   subject="Subject of the email",
                   body = "Body of the email",
                   smtp = list(host.name = "aspmx.l.google.com", port = 25),
                   authenticate = FALSE,
                   send = FALSE)


expect_identical(.jclass(email), "org.apache.commons.mail.SimpleEmail")

context("Email content")
expect_identical(email$getSubject(), "Subject of the email")

context("Recipients")
expect_identical(.jstrVal(email$getToAddresses()), "[recipient1@gmail.com, recipient2@gmail.com]")
expect_identical(.jstrVal(email$getCcAddresses()), "[]")
expect_identical(.jstrVal(email$getBccAddresses()), "[]")
expect_identical(.jstrVal(email$getFromAddress()), "sender@gmail.com")

context("SMTP settings")
expect_identical(email$getHostName(), "aspmx.l.google.com")
expect_identical(email$getSmtpPort(), "25")
expect_false(email$isSSL())
expect_false(email$isTLS())


email <- send.mail(from = "sender@gmail.com",
                   to = c("recipient1@gmail.com", "recipient2@gmail.com"),
                   cc = c("recipientcc@gmail.com"),
                   bcc = c("recipientbcc@gmail.com"),
                   subject = "Subject of the email",
                   body = "Body of the email",
                   smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = TRUE),
                   authenticate = TRUE,
                   send = FALSE)


expect_identical(.jclass(email), "org.apache.commons.mail.SimpleEmail")

context("Email content")
expect_identical(email$getSubject(), "Subject of the email")

context("Recipients")
expect_identical(.jstrVal(email$getToAddresses()), "[recipient1@gmail.com, recipient2@gmail.com]")
expect_identical(.jstrVal(email$getCcAddresses()), "[recipientcc@gmail.com]")
expect_identical(.jstrVal(email$getBccAddresses()), "[recipientbcc@gmail.com]")
expect_identical(.jstrVal(email$getFromAddress()), "sender@gmail.com")

context("SMTP settings")
expect_identical(email$getHostName(), "smtp.gmail.com")
expect_identical(email$getSmtpPort(), "465")
expect_true(email$isSSL())
expect_false(email$isTLS())


email <- send.mail(from = "sender@gmail.com",
                   to = c("recipient1@gmail.com", "recipient2@gmail.com"),
                   subject = "Subject of the email",
                   body = "Body of the email",
                   smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "gmail_username", passwd = "password", ssl = TRUE),
                   authenticate = TRUE,
                   send = FALSE,
                   attach.files = c("./download.log", "./upload.log"),
                   file.names = c("Download log", "Upload log"), # optional parameter
                   file.descriptions = c("Description for download log", "Description for upload log"))


expect_identical(.jclass(email), "org.apache.commons.mail.MultiPartEmail")

context("Email content")
expect_identical(email$getSubject(), "Subject of the email")

context("Recipients")
expect_identical(.jstrVal(email$getToAddresses()), "[recipient1@gmail.com, recipient2@gmail.com]")
expect_identical(.jstrVal(email$getCcAddresses()), "[]")
expect_identical(.jstrVal(email$getBccAddresses()), "[]")
expect_identical(.jstrVal(email$getFromAddress()), "sender@gmail.com")

context("SMTP settings")
expect_identical(email$getHostName(), "smtp.gmail.com")
expect_identical(email$getSmtpPort(), "465")
expect_true(email$isSSL())
expect_false(email$isTLS())
expect_true(email$isBoolHasAttachments())


