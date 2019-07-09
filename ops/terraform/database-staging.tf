

# = = = = = = = = = = = = = = = = = = = = = = 
# Cakephp SQL
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_sql_database_instance" "cakephp-staging" {
  name             = "cakephp-staging-instance"
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

resource "google_sql_database" "cakephp-staging" {
  name      = "staging_frontend"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.cakephp-staging.name}"
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "cakephp-staging-user" {
  name     = "root"
  instance = "${google_sql_database_instance.cakephp-staging.name}"
  password = "${var.sql_password}"
}

# = = = = = = = = = = = = = = = = = = = = = = 
# Revel SQL
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_sql_database_instance" "revel-staging" {
  name             = "revel-staging-instance"
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

resource "google_sql_database" "revel-staging" {
  name      = "staging_backend"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.revel-staging.name}"
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "revel-staging-user" {
  name     = "root"
  instance = "${google_sql_database_instance.revel-staging.name}"
  password = "${var.sql_password}"
}



