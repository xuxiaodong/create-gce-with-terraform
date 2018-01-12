provider "google" {
    credentials = "${file("account.json")}"
    project = "${var.project}"
    region = "${var.region}"
}

resource "google_compute_network" "selfhost" {
    name = "selfhost-network"
}

resource "google_compute_firewall" "selfhost" {
    name = "selfhost-firewall"
    network = "${google_compute_network.selfhost.name}"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = "${var.ports}"
    }
}

resource "google_compute_instance" "selfhost" {
    name = "selfhost"
    machine_type = "${var.machine_type}"
    zone = "${var.region}"

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-9"
        }
    }

    network_interface {
        network = "${google_compute_network.selfhost.name}"

        access_config = {}
    }

    metadata {
        sshKeys = "selfhost:${chomp(file("id_rsa.pub"))}"
    }

    provisioner "local-exec" {
        command = "echo '[selfhost]\n${google_compute_instance.selfhost.network_interface.0.access_config.0.assigned_nat_ip}' > ../../inventory/selfhost"
    }
}
