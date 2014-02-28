\name{valid.email}
\alias{valid.email}
\title{Uses regex to validate email addresses}
\usage{
valid.email(emails)
}
\arguments{
  \item{emails}{A character vector of email addresses.}
}
\value{
TRUE Boolean TRUE if all items in 'emails' are valid
emails. If a malformed email address is identified, the
function stops execution of the calling function
'send.mail' and prints the relevant item to console.
}
\description{
Uses regex to validate email addresses
}

