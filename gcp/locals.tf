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

    subnets = tomap({
        for_load_balancer = {
            name = "the-stocker-subnet-for-load-balancer"
            cidr_range = "10.0.0.0/27"
        }
        for_cloud_sql = {
            name = "the-stocker-subnet-for-cloud-sql"
            cidr_range = "10.1.0.0/23"
        }
    })
}