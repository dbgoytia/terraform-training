module "s3_mod" {
  source = "../../../modules/services/s3"

  s3_bucket_name  = "bucket-lifecyle-lab"
  days_to_IA      = 30
  days_to_GLACIER = 60
  days_to_EXPIRE  = 90
}