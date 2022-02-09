resource "aws_instance" "instances" {
  # AMI to user for provisioning EC2s
  ami           = var.ami
  instance_type = var.instance_type

  # root volume details like volume size, type
  root_block_device {
    volume_size = var.root_block_device.volume_size
    volume_type = var.root_block_device.volume_type
  }

  # Dynamically create EBS volumes and attach to EC2 at the time of creation. ebs_block_device variable accepts a list of maps.
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }
}