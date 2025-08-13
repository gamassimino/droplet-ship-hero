# address IP
output "address" {
  description = "La address IP"
  value       = google_compute_address.static_ip.address
}
