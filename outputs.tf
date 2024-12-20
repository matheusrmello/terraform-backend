output "instance_id" {
  value       = [aws_instance.instance-docker.id, aws_instance.instance-k8s.id]
  description = "ID da instância EC2 criada"
}

output "public_ip" {
  value       = [aws_instance.instance-docker.public_ip, aws_instance.instance-k8s.public_ip]
  description = "Endereço IP público da instância EC2"
}

output "private_ip" {
  value       = [aws_instance.instance-docker.private_ip, aws_instance.instance-k8s.private_ip]
  description = "Endereço IP privado da instância EC2"
}