variable "bucket-name" {
    description = "The name of the bucket to host static website."
    type = string
}

variable "acl-kind" {
    description = "Either public or private."
    type = string
}

variable "environment" {
    description = "The environment in which we're deploying. (dev/qa/prod) (or others)."
    type = string
    default = "stage"
}