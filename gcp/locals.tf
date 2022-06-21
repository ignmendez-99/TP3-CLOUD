locals {

    gcs = {
        objects = {
            index = {
                filename = "index.html"
                content_type = "text/html"
            }
            error = {
                filename = "error.html"
                content_type = "text/html"
            }
        }
    }

    ssl = {
        key = {
            filename = "private.key"
        }
        certificate = {
            filename = "certificate.crt"
        }
    }

    subnets = tomap({
        for_cloud_sql = {
            name = "the-stocker-subnet-for-cloud-sql"
            cidr_range = "10.1.0.0/23"
        }
    })

    cloud_run = {
        services = {
            user_service = {
                name = "user-service"
                image = "us-docker.pkg.dev/cloudrun/container/hello"
            }
            post_service = {
                name = "post-service"
                image = "us-docker.pkg.dev/cloudrun/container/hello"
            }
            ask_me_anything_service = {
                name = "ask-me-anything-service"
                image = "us-docker.pkg.dev/cloudrun/container/hello"
            }
            feed_service = {
                name = "feed-service"
                image = "us-docker.pkg.dev/cloudrun/container/hello"
            }
        }
    }
}