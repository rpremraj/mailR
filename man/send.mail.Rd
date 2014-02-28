\name{send.mail}
\alias{send.mail}
\title{Send emails from R to multiple recipients with attachments and SMTP authorization}
\usage{
send.mail(from, to, subject = "", body = "", smtp = list(),
  authenticate = FALSE, send = TRUE, attach.files = NULL, ...)
}
\arguments{
  \item{from}{A valid email address of the sender.}

  \item{to}{A character vector of recipient valid email
  addresses.}

  \item{subject}{Subject of the email.}

  \item{body}{Body of the email as text.}

  \item{smtp}{A list of configuration parameters to
  establish and authorize a connection with the SMTP
  server. See details for the various parameters.}

  \item{authenticate}{A boolean variable to indicate
  whether authorization is required to connect to the SMTP
  server. If set to true, see details on parameters
  required in smtp parameter.}

  \item{send}{A boolean indicating whether the email should
  be sent at the end of the function (default behaviour).
  If set to false, function returns the email object to the
  parent environment.}

  \item{attach.files}{A character vector of paths in the
  file system linking to files to be attached to the email}

  \item{...}{Optional arguments to be passed related to
  file attachments. See details for more info.}
}
\value{
email A Java object of class
org.apache.commons.mail.SimpleEmail or
org.apache.commons.mail.MultiPartEmail
}
\description{
Send emails from R to multiple recipients with attachments
and SMTP authorization
}
\details{
The only mandatory value in the list 'smtp' is host.name
that is the SMTP server address. A port number can also be
provided via the list item 'port'. In case the SMTP server
requires authorization, the parameter 'authenticate' must
be set to TRUE and the list 'smtp' must include items
'user.name' and 'passwd'. If SSL or TLS encryption is
required by the SMTP server, these can be indicated by
setting a list item 'ssl' as TRUE or 'tls' as TRUE
respectively.

Two optional paramters relevant to attachments can be
supplied. Parameter 'file.names' can be provided to assign
names to the files listed in the parameter 'attach.files'.
A description can be provided further as
'file.descriptions' to further describe the file. Both
parameters must have the same length as 'attach.files'. In
case attach.file is NULL, then these two parameters will be
ignored.
}
\examples{
send.mail(from = "sender@gmail.com",
          to = c("recipient1@gmail.com", "recipient2@gmail.com"),
          subject="Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "aspmx.l.google.com", port = 25),
          authenticate = FALSE,
          send = TRUE)
}

