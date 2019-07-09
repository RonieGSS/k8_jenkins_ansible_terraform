
# = = = = = = = = = = = = = = = = = = = = = = 
# Cakephp SQL
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_sql_database_instance" "cakephp-production" {
  name             = "cakephp-production-instance"
  database_version = "MYSQL_5_6"
  region           = "${var.region}"
  project          = "${var.project}"
  settings {
    tier              = "db-n1-standard-1"
    activation_policy = "ALWAYS"

    ip_configuration {
      authorized_networks = [
        "${data.null_data_source.auth_mysql_allowed_1.*.outputs}"
      ]
    }
  }
}

resource "google_sql_database" "cakephp-production" {
  name      = "production_frontend"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.cakephp-production.name}"
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "cakephp-prod-user" {
  name     = "root"
  instance = "${google_sql_database_instance.cakephp-production.name}"
  password = "${var.sql_password}"
}

# = = = = = = = = = = = = = = = = = = = = = = 
# Revel SQL
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_sql_database_instance" "revel-production" {
  name             = "revel-production-instance"
  database_version = "MYSQL_5_6"
  region           = "${var.region}"
  project          = "${var.project}"
  settings {
    tier              = "db-n1-standard-1"
    activation_policy = "ALWAYS"

    ip_configuration {
      authorized_networks = [
        "${data.null_data_source.auth_mysql_allowed_1.*.outputs}"
      ]
    }
  }
}

resource "google_sql_database" "revel-production" {
  name      = "production_backend"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.revel-production.name}"
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "revel-prod-user" {
  name     = "root"
  instance = "${google_sql_database_instance.revel-production.name}"
  password = "${var.sql_password}"
}

