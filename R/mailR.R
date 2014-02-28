#' Internal function to create file attachment objects 
#'
#' @param attach.files A character vector of paths to files in the file system to be attached.
#' @param dots A list generated from the ellipsis parameters in send.mail. See details for more info.
#' @return attachments A vector of Java objects of class org.apache.commons.mail.EmailAttachment
#' @details The relevant optional parameters include 'file.names' listing names to assign to the attached files and 'file.descriptions' that are descriptions to be assigned to the files. If included, both paramters should be of the same length as 
createEmailAttachments <- function(attach.files, dots = NULL)
{
  if(is.null(attach.files) | !all(sapply(c(attach.files), file.exists)))
    stop("Argument 'file.name' must link to valid files")
  
  file.names <- NULL
  file.descriptions <- NULL
  
  if(!is.null(dots))
  {
    if("file.names" %in% names(dots))
      file.names <- dots$file.names
    
    if("file.descriptions" %in% names(dots))
      file.descriptions <- dots$file.descriptions
  }
  
  if(!is.null(file.names) & length(file.names) != length(attach.files))
    stop("If not NULL, length of argument 'file.names' must equal length of argument 'file.paths'")
  
  if(!is.null(file.descriptions) & length(file.descriptions) != length(attach.files))
    stop("If not NULL, Length of argument 'file.descriptions' must equal length of argument 'file.paths'")
  
  attachments <- list()
  
  for(i in 1:length(attach.files))
  {
    attachments[[i]] <- .jnew("org.apache.commons.mail.EmailAttachment")
    attachments[[i]]$setPath(attach.files[i])
    if(!is.null(file.names)) attachments[[i]]$setName(file.names[i])
    if(!is.null(file.descriptions)) attachments[[i]]$setDescription(file.descriptions[i])
  }
  
  return(attachments)
}

#' Internal function to establish authenticated connection with SMTP server
#'
#' @param smtp A list of parameters to establish and authorize a connection with the SMTP server. See details for the various parameters.
#' @return smtp.authentication A Java object of class 'org.apache.commons.mail.DefaultAuthenticator'
authenticateSMTP <- function(smtp)
{
  if(!all(c("user.name", "passwd") %in% names(smtp)))
    stop("Username and password required for SMTP authentication.")
  
  smtp.authentication <- .jnew("org.apache.commons.mail.DefaultAuthenticator", smtp$user.name, smtp$passwd)  
  
  return(smtp.authentication)
}

#' Send emails from R to multiple recipients with attachments and SMTP authorization
#'
#' @param from A valid email address of the sender.
#' @param to A character vector of recipient valid email addresses.
#' @param subject Subject of the email.
#' @param body Body of the email as text.
#' @param smtp A list of configuration parameters to establish and authorize a connection with the SMTP server. See details for the various parameters.
#' @param authenticate A boolean variable to indicate whether authorization is required to connect to the SMTP server. If set to true, see details on parameters required in smtp parameter.
#' @param send A boolean indicating whether the email should be sent at the end of the function (default behaviour). If set to false, function returns the email object to the parent environment.
#' @param attach.files A character vector of paths in the file system linking to files to be attached to the email
#' @param ... Optional arguments to be passed related to file attachments. See details for more info. 
#' @return email A Java object of class org.apache.commons.mail.SimpleEmail or org.apache.commons.mail.MultiPartEmail
#' @details The only mandatory value in the list 'smtp' is host.name that is the SMTP server address. A port number can also be provided via the list item 'port'. In case the SMTP server requires authorization, the parameter 'authenticate' must be set to TRUE and the list 'smtp' must include items 'user.name' and 'passwd'. If SSL or TLS encryption is required by the SMTP server, these can be indicated by setting a list item 'ssl' as TRUE or 'tls' as TRUE respectively.
#' 
#' Two optional paramters relevant to attachments can be supplied. Parameter 'file.names' can be provided to assign names to the files listed in the parameter 'attach.files'. A description can be provided further as 'file.descriptions' to further describe the file. Both parameters must have the same length as 'attach.files'. In case attach.file is NULL, then these two parameters will be ignored.
#' @export send.mail
#' @examples
#' send.mail(from = "sender@@gmail.com",
#'           to = c("recipient1@@gmail.com", "recipient2@@gmail.com"),
#'           subject="Subject of the email",
#'           body = "Body of the email",
#'           smtp = list(host.name = "aspmx.l.google.com", port = 25),
#'           authenticate = FALSE,
#'           send = TRUE)
send.mail <- function(from, to, subject = "", body = "", smtp = list(), authenticate = FALSE, send = TRUE, attach.files = NULL, ...)
{
  if (length(from) != 1) 
    stop("Argument 'from' must be a single (valid) email address.")
  valid.email(from)
  
  if(!all(c("host.name") %in% names(smtp)))
    stop("Check documentation to include all mandatory parameters to establisg SMTP connection.")
  
  dots <- list(...)
  
  if(!is.null(attach.files))
  {
    email <- .jnew("org.apache.commons.mail.MultiPartEmail")
    attachments <- createEmailAttachments(attach.files, dots)
    sapply(attachments, email$attach)
  }
  else
    email <- .jnew("org.apache.commons.mail.SimpleEmail")
  
  email$setHostName(smtp$host.name)
  if("port" %in% names(smtp))
    email$setSmtpPort(as.integer(smtp$port));
  
  if(authenticate == TRUE)
    email$setAuthenticator(authenticateSMTP(smtp));
  
  
  if("ssl" %in% names(smtp))
    if(smtp$ssl)
      email$setSSLOnConnect(TRUE)
  
  if("tls" %in% names(smtp))
    if(smtp$ssl)
      email$setStartTLSEnabled(TRUE)
  
  email$setFrom(from)
  email$setSubject(subject)
  email$setMsg(body)
  
  if(length(to) > 0)
  {
    if(valid.email(to))
      sapply(to, email$addTo)
  }
  
  if("cc" %in% names(dots))
  {
    if(valid.email(dots$cc))
      sapply(dots$cc, email$addCc)
  }
  
  if("bcc" %in% names(dots))
  {
    if(valid.email(dots$bcc))
      sapply(dots$bcc, email$addBcc)
  }
  
  if("replyTo" %in% names(dots))
  {
    if(valid.email(dots$replyTo))
      sapply(dots$replyTo, email$addReplyTo)
  }
  
  if(send)
    email$send()
  
  return(email)
}

#' Uses regex to validate email addresses
#'
#' @param emails A character vector of email addresses.
#' @return TRUE Boolean TRUE if all items in 'emails' are valid emails. If a malformed email address is identified, the function stops execution of the calling function 'send.mail' and prints the relevant item to console.
# @examples
# valid.email("<user@@email.com>") # TRUE

valid.email <- function(emails)
{
  pattern <- "^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$"
  results <- regexpr(pattern, emails)
  if(any(results == -1))
    stop(sprintf("Invalid email address(es) %s", paste(emails[which(results == -1)], collapse = ", ")))
  
  return(TRUE)
}
