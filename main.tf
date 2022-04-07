# Find all availabe availability zones.
data "google_compute_zones" "available" {}

# Create instances.
resource "google_compute_instance" "default" {
  count        = 5
  name         = "test-${count.index}"
  machine_type = "e2-medium"
  # Select a zone from the available zones. This loops over zones, placing instances:
  # If there are 3 zones found, and 5 instances:
  # | instance | zone |
  # |----------|------|
  # | test-0   | a    |
  # | test-1   | b    |
  # | test-2   | c    |
  # | test-3   | a    |
  # | test-4   | b    |
  zone = data.google_compute_zones.available.names[ count.index % length(data.google_compute_zones.available.names) ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }
}
