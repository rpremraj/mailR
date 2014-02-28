\name{createEmailAttachments}
\alias{createEmailAttachments}
\title{Internal function to create file attachment objects}
\usage{
createEmailAttachments(attach.files, dots = NULL)
}
\arguments{
  \item{attach.files}{A character vector of paths to files
  in the file system to be attached.}

  \item{dots}{A list generated from the ellipsis parameters
  in send.mail. See details for more info.}
}
\value{
attachments A vector of Java objects of class
org.apache.commons.mail.EmailAttachment
}
\description{
Internal function to create file attachment objects
}
\details{
The relevant optional parameters include 'file.names'
listing names to assign to the attached files and
'file.descriptions' that are descriptions to be assigned to
the files. If included, both paramters should be of the
same length as
}

