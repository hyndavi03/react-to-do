variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"  # Change to your desired region
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default     = []  # Add your subnet IDs here
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []  # Add your security group IDs here
}

variable "docker_image" {
  description = "Docker image for the ECS task"
  type        = string
  default     = "react-repo/react-app:latest"  # Replace with your Docker image
}
