output "instance_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.ec2.public_ip
}

output "aws_region" {
  value = var.aws_region
}

