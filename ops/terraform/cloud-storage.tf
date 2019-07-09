
# = = = = = = = = = = = = = = = = = = = = = = 
# Cloud Storage
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_storage_bucket" "production-uploaded-files-store" {
  name          = "production-uploaded-files-store"
  location      = "ASIA"
  storage_class = "STANDARD"
}

resource "google_storage_bucket" "staging-uploaded-files-store" {
  name          = "staging-uploaded-files-store"
  location      = "ASIA"
  storage_class = "STANDARD"
}

resource "google_storage_bucket" "tfstate-store" {
  name          = "tfstate-bucket"
  location      = "ASIA"
  storage_class = "STANDARD"
}
