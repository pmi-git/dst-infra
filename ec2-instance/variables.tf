variable "aws_region" {
  description = "Région AWS"
  default     = "us-east-2"
}

variable "my_ip_cidr" {
  description = "Ton IP publique (avec /32)"
}

variable "aws_profile" {
  description = "Nom du profil AWS local (dans ~/.aws/credentials)"
  default     = "default"
}

variable "instance_type" {
  description = "Type d'instance EC2 (t3.micro, t3.small, t3.medium, t3.large, etc.)"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Nom de la clé SSH (doit être unique sur AWS)"
}

variable "public_key_path" {
  description = "Chemin local vers la clé publique SSH (ex: ~/.ssh/id_rsa.pub)"
}
