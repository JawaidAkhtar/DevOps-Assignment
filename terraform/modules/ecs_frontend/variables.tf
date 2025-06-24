variable "image_uri" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "target_group_arn" {
  type = string
}
