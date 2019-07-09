
# = = = = = = = = = = = = = = = = = = = = = = 
# DNS TXT
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_dns_record_set" "ev-email" {
  name = "ev.${var.template_dns_name}"
  managed_zone = "${var.template_zone}"
  type = "TXT"
  ttl  = 300

  rrdatas = ["\"v=spf1 include:mailgun.org ~all\""]
}

resource "google_dns_record_set" "krs-domainkey-email" {
  name = "krs._domainkey.ev.${var.template_dns_name}"
  managed_zone = "${var.template_zone}"
  type = "TXT"
  ttl  = 300

  rrdatas = ["\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDKkmCAjuSkvTYzhH1p69afWHNVTC/MY1egFRryyWsk9\""]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# DNS CNAME
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_dns_record_set" "ev-cname" {
  name = "mail.ev.${var.template_dns_name}"
  managed_zone = "${var.template_zone}"
  type = "CNAME"
  ttl  = 300

  rrdatas = ["mailgun.org."]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# DNS MX
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_dns_record_set" "ev-mx" {
  name = "ev.${var.template_dns_name}"
  managed_zone = "${var.template_zone}"
  type = "MX"
  ttl  = 3600

  rrdatas = [
    "10 mxa.mailgun.org.",
    "10 mxb.mailgun.org."
  ]
}