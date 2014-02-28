\name{authenticateSMTP}
\alias{authenticateSMTP}
\title{Internal function to establish authenticated connection with SMTP server}
\usage{
authenticateSMTP(smtp)
}
\arguments{
  \item{smtp}{A list of parameters to establish and
  authorize a connection with the SMTP server. See details
  for the various parameters.}
}
\value{
smtp.authentication A Java object of class
'org.apache.commons.mail.DefaultAuthenticator'
}
\description{
Internal function to establish authenticated connection
with SMTP server
}

