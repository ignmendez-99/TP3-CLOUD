# module "gcs" {
#   for_each = local.gcs
#   source =  "../modules/gcs"

#   bucket_name = each.value.bucket_name
#   website     = true
#   objects     = try(each.value.objects, {})
# }
