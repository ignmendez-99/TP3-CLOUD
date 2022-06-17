# locals {
#   bucket_name = "www.the-stocker.com"
#   path        = "resources"

#   gcs = {

#     # 1 - Website
#     website = {
#       bucket_name = local.bucket_name
#       path        = "resources"

#       objects = {
#         index = {
#           filename     = "html/index.html"
#           content_type = "text/html"
#         }
#         error = {
#           filename     = "html/error.html"
#           content_type = "text/html"
#         }
#       }
#     }

#   }
# }