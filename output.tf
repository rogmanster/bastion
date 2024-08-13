# Bastion
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

# Jumpbox
output "jumpbox_private_ip" {
  value = aws_instance.private.private_ip
}

