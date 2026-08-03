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

# Install CloudWatch Agent

wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

dpkg -i amazon-cloudwatch-agent.deb

# Create CloudWatch Agent configuration
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

cat <<CONFIG >/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {
    "metrics_collection_interval": 60
  },
  "metrics": {
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "resources": [
          "/"
        ]
      }
    }
  }
}
CONFIG

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
-s

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