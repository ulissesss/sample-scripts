output "server_id" {
  value = aws_instance.linux-server.id
}

output "server_private_ip" {
  value = aws_instance.linux-server.private_ip

}

output "elasitc_ip" {
  value = aws_eip.linux-eip.public_ip
}