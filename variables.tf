variable "project" {
    description = "Google Cloud project ID"
}

variable "region" {
    description = "Google Cloud datacenter"
    default = "asia-east1-c"
}

variable "machine_type" {
    description = "Google Cloud instance type"
    default = "f1-micro"
}

variable "ports" {
    description = "Google Cloud open ports"
    default = ["22", "8530"]
}
