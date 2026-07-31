resource "aws_launch_template" "app" {
  
  image_id = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.ec2_security_group_id]
iam_instance_profile {
  name = var.instance_profile_name
}

 monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

    block_device_mappings {
    device_name = "/dev/xvda"

    ebs{
        volume_size = 20
        volume_type = "gp3"
        encrypted = true
        delete_on_termination = false
    }
  }

    user_data = base64encode(<<EOF
#!/bin/bash
apt-get update -y
apt-get install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<h1>Terraform Production Server</h1>" > /usr/share/nginx/html/index.html
EOF
)

tags = merge(
  var.common_tags,
  {
    Name = "${var.name_prefix}-launch-template"
  }
)

tag_specifications {
  resource_type = "instance"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-app-server"
    }
  )
}

tag_specifications {
  resource_type = "volume"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-app-volume"
    }
  )


 }
} 