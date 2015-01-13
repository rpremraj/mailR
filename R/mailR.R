#' Internal function to create file attachment objects 
#'
#' @param attach.files A character vector of paths to files in the file system or valid URLs to be attached.
#' @param dots A list generated from the ellipsis parameters in send.mail. See details for more info.
#' @return attachments A vector of Java objects of class org.apache.commons.mail.EmailAttachment
#' @details The relevant optional parameters include 'file.names' listing names to assign to the attached files and 'file.descriptions' that are descriptions to be assigned to the files. If included, both paramters should be of the same length as 
.createEmailAttachments <- function(attach.files, dots = NULL)
{
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
    if(isUrl(attach.files[i]))
      attachments[[i]]$setURL(.jnew("java.net.URL", attach.files[i]))
    else
    {
      if(file.exists(attach.files[i]))
        attachments[[i]]$setPath(normalizePath(attach.files[i]))
      else
        stop("Argument 'attach.files' must link to valid files")
    }

    if(!is.null(file.names)) attachments[[i]]$setName(file.names[i])
    if(!is.null(file.descriptions)) attachments[[i]]$setDescription(file.descriptions[i])
  }
  
  return(attachments)
}

#' Internal function to embed referenced images as inline 
#'
#' @param image.file.locations A vector of paths to images files in the file system to be embedded
#' @return file.resolver A vector of Java objects of class org.apache.commons.mail.resolver.DataSourceFileResolver
#' @details This is an internal function that performs the groundwork to embed images as inline. 
.resolveInlineImages <- function(image.file.locations)
{
  base_dir <- .jnew("java.io.File", normalizePath(getwd()))
  file.resolver <- .jnew("org.apache.commons.mail.resolver.DataSourceFileResolver", base_dir)
  sapply(image.file.locations, file.resolver$resolve)
  
  return(file.resolver)
}

#' Internal function to establish authenticated connection with SMTP server
#'
#' @param smtp A list of parameters to establish and authorize a connection with the SMTP server. See details for the various parameters.
#' @return smtp.authentication A Java object of class 'org.apache.commons.mail.DefaultAuthenticator'
.authenticateSMTP <- function(smtp)
{
  if(!all(c("user.name", "passwd") %in% names(smtp)))
    stop("Username and password required for SMTP authentication.")
  
  smtp.authentication <- .jnew("org.apache.commons.mail.DefaultAuthenticator", smtp$user.name, smtp$passwd)  
  
  return(smtp.authentication)
}

#' Internal function to set encoding of the email
#'

#' @param email Commons email object
#' @param encoding Character encoding to use for the email. Supported encodings include iso-8859-1 (default), utf-8, us-ascii, and koi8-r. 
#' @return email Commons email object with set encoding
.resolveEncoding <- function(email, encoding)
{
  switch(encoding,
         "iso-8859-1" = {email$setCharset("iso-8859-1")},
         "utf-8" = {email$setCharset("utf-8")},
         "us-ascii" = {email$setCharset("us-ascii")},
         "koi8-r" = {email$setCharset("koi8-r")},
         stop("Supported encodings include iso-8859-1, utf-8, us-ascii, and koi8-r only.")
  )  
  return(email)
}

#' Send emails from R
#'
#' @param from A valid email address of the sender.
#' @param to A character vector of recipient valid email addresses.
#' @param subject Subject of the email.
#' @param body Body of the email as text. If the parameter body refers to an existing file location, the text of the file is parsed as body of the email.
#' @param encoding Character encoding to use for the email. Supported encodings include iso-8859-1 (default), utf-8, us-ascii, and koi8-r.
#' @param html A boolean indicating whether the body of the email should be parsed as HTML.
#' @param inline A boolean indicating whether images in the HTML file should be embedded inline.
#' @param smtp A list of configuration parameters to establish and authorize a connection with the SMTP server. See details for the various parameters.
#' @param authenticate A boolean variable to indicate whether authorization is required to connect to the SMTP server. If set to true, see details on parameters required in smtp parameter.
#' @param send A boolean indicating whether the email should be sent at the end of the function (default behaviour). If set to false, function returns the email object to the parent environment.
#' @param attach.files A character vector of paths in the file system linking to files or *valid* URLs to be attached to the email (see details for more info on attaching URLs)
#' @param debug A boolean indicating whether you wish to see detailed debug info
#' @param ... Optional arguments to be passed related to file attachments. See details for more info. 
#' @return email A Java object of class org.apache.commons.mail.SimpleEmail or org.apache.commons.mail.MultiPartEmail
#' @details The only mandatory value in the list 'smtp' is host.name that is the SMTP server address. A port number can also be provided via the list item 'port'. In case the SMTP server requires authorization, the parameter 'authenticate' must be set to TRUE and the list 'smtp' must include items 'user.name' and 'passwd'. If SSL or TLS encryption is required by the SMTP server, these can be indicated by setting a list item 'ssl' as TRUE or 'tls' as TRUE respectively.
#' 
#' Using 'attach.files' you can attach files or webpages hosted on the web (for e.g. on Dropbox). Currently, URLs hostnames must be prepending with http:// or https://. Two optional paramters relevant to attachments can be supplied. Parameter 'file.names' can be provided to assign names to the files listed in the parameter 'attach.files'. A description can be provided further as 'file.descriptions' to further describe the file. Both parameters must have the same length as 'attach.files'. In case attach.file is NULL, then these two parameters will be ignored.
#'
#' HTML formatted emails can be sent by setting the parameters html and inline (if embedding images) to TRUE. The body of the email can either be a HTML string or point to a HTML file in the local file system.
#' @export send.mail
#' @import rJava
#' @import stringr
#' @import R.utils
#' @note For more examples, see https://github.com/rpremraj/mailR 
#' @examples
#' sender <- "sender@@gmail.com"  # Replace with a valid address
#' recipients <- c("receiver1@@gmail.com")  # Replace with one or more valid addresses
#' email <- send.mail(from = sender,
#'                    to = recipients,
#'                    subject="Subject of the email",
#'                    body = "Body of the email",
#'                    smtp = list(host.name = "aspmx.l.google.com", port = 25),
#'                    authenticate = FALSE,
#'                    send = FALSE)
#' \dontrun{email$send() # execute to send email}
send.mail <- function(from, to, subject = "", body = "", encoding = "iso-8859-1", html = FALSE, inline = FALSE, smtp = list(), authenticate = FALSE, send = TRUE, attach.files = NULL, debug = FALSE, ...)
{
  if (length(from) != 1) 
    stop("Argument 'from' must be a single (valid) email address.")
  
  if (!length(to) > 0) 
    stop("Argument 'to' must have at least one single (valid) email address.")
  
  if(!all(c("host.name") %in% names(smtp)))
    stop("Check documentation to include all mandatory parameters to establisg SMTP connection.")
  
  dots <- list(...)
  
  if(html && inline)
    email <- .jnew("org.apache.commons.mail.ImageHtmlEmail")
  else if(html)
    email <- .jnew("org.apache.commons.mail.HtmlEmail")
  else if(!is.null(attach.files))
    email <- .jnew("org.apache.commons.mail.MultiPartEmail")
  else
    email <- .jnew("org.apache.commons.mail.SimpleEmail")
  
  if(debug)
    email$setDebug(TRUE)
  
  email <- .resolveEncoding(email, encoding)
  
  if(!is.null(attach.files))
  {
    attachments <- .createEmailAttachments(attach.files, dots)
    sapply(attachments, email$attach)
  }
  
  if(.jclass(email) == "org.apache.commons.mail.ImageHtmlEmail")
  {
    image.files.references <- str_extract_all(body, email$REGEX_IMG_SRC)
    pattern <- "\"([^\"]*)\""
    image.files.locations <- gsub("\"", "", sapply(str_extract_all(image.files.references[[1]], pattern), "[[", 1))
    file.resolver <- .resolveInlineImages(image.files.locations)
    email$setDataSourceResolver(file.resolver)  
  }
  
  email$setHostName(smtp$host.name)
  
  if("port" %in% names(smtp))
    email$setSmtpPort(as.integer(smtp$port));
  
  if(authenticate == TRUE)
    email$setAuthenticator(.authenticateSMTP(smtp));
  
  if("ssl" %in% names(smtp))
    if(smtp$ssl)
      email$setSSL(TRUE)
  
  if("tls" %in% names(smtp))
    if(smtp$tls)
      email$setTLS(TRUE)
  
  email$setFrom(from)
  email$setSubject(subject)
  
  if(file.exists(body))
    body <- readChar(body, file.info(body)$size)
  
  if(html)
  {
    email$setHtmlMsg(as.character(body))
    email$setTextMsg("Your email client does not support HTML messages")
  } else
    email$setMsg(as.character(body))
  
  if(.valid.email(to))
    sapply(to, email$addTo)
  
  if("cc" %in% names(dots))
  {
    if(.valid.email(dots$cc))
      sapply(dots$cc, email$addCc)
  }
  
  if("bcc" %in% names(dots))
  {
    if(.valid.email(dots$bcc))
      sapply(dots$bcc, email$addBcc)
  }
  
  if("replyTo" %in% names(dots))
  {
    if(.valid.email(dots$replyTo))
      sapply(dots$replyTo, email$addReplyTo)
  }
  
  if(send)
    .jTryCatch(email$send())
  
  return(email)
}

#' Internal function to validate email addresses
#'
#' @param emails A character vector of email addresses.
#' @return TRUE Boolean TRUE if all items in 'emails' are valid emails. If a malformed email address is identified, the function stops execution of the calling function 'send.mail' and prints the relevant item to console.
# @examples
# .valid.email("<user@@email.com>") # TRUE

.valid.email <- function(emails)
{
  for(i in emails)
  {
    .jTryCatch(.jnew("javax.mail.internet.InternetAddress", i))
  }
  gc()
  return(TRUE)
}

#' Internal function to catch Java exceptions and print stack traces. Inspired by author of package XLConnect.
#' @param ... A call to a Java method
.jTryCatch <- function(...) {
  tryCatch(..., Throwable = 
             function(e) {
               if(!is.jnull(e$jobj)) {
                 
                 print(e$jobj$printStackTrace())
                 stop(paste(class(e)[1], e$jobj$getMessage(), sep = " (Java): "), call. = FALSE)
               } else 
                 stop("Undefined error occurred! Turn debug mode on to see more details.")
             }
  )
}
