variable "region" {
  default = "us-gov-east-1"
}

variable "root_block_device" {
  type = object({
    volume_size = number
    volume_type = string
  })

  default = {
    volume_size = 150
    volume_type = "gp2"
  }

  validation {
    condition     = var.root_block_device.volume_size >= 150 && var.root_block_device.volume_size <= 500
    error_message = "The volume_size value must >= 150 and <= 500."
  }

  validation {
    condition     = contains(["gp2", "gp3"], var.root_block_device.volume_type)
    error_message = "Acceptable 'volume_type' value includes ['gp2' | 'gp3']."
  }
}

variable "ebs_block_devices" {
  type = list(object({
    device_name = string
    encrypted   = bool
    volume_size = number
    volume_type = string
  }))

  default = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 150
      encrypted   = true
    },
    {
      device_name = "/dev/sdg"
      volume_type = "gp2"
      volume_size = 500
      encrypted   = true
    }
  ]

  validation {
    condition = alltrue([
      for o in var.ebs_block_devices : contains(["gp2", "gp3"], o.volume_type)
    ])
    error_message = "Acceptable 'volume_type' values includes ['gp2' | 'gp3']."
  }

  validation {
    condition = alltrue([
      for o in var.ebs_block_devices : o.volume_size >= 150 && o.volume_size <= 500
    ])
    error_message = "The volume_size value must >= 150 and <= 500."
  }
}

variable "ami" {
  description = "amazon machine image"
  default     = "ami-01d91d548d47f8858"
}

variable "instance_type" {
  description = "amazon instance type"
  default     = "t3.micro"
}