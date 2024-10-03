terraform {
  backend "s3" {
    bucket = "docker"
    key    = "nginx-app/terraform.tfstate"

    endpoints = { s3 = "MINIO_ENDPOINT_PLACEHOLDER"}

    access_key = "MINIO_ACCESS_KEY_PLACEHOLDER"
    secret_key = "MINIO_SECRET_KEY_PLACEHOLDER"

    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
    skip_requesting_account_id  = true
  }
}