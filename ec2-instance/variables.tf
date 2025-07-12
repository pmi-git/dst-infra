variable "aws_region" {
  description = "Région AWS"
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "Nom du profil AWS local (dans ~/.aws/credentials)"
  default     = "default"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nom de la clé SSH (doit être unique sur AWS)"
}

variable "public_key_path" {
  description = "Chemin local vers la clé publique SSH (ex: ~/.ssh/id_rsa.pub)"
}
