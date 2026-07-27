#ALB Security Group allowing HTTP & HTTPS Traffic
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
  tags = merge(
     var.common_tags,
     {
        Name = "${var.name_prefix}-alb-sg"
     }
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
    security_group_id = aws_security_group.alb_sg.id
    description = "http"

    from_port = 80
    to_port = 80
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
    security_group_id = aws_security_group.alb_sg.id
    description = "https"

    from_port = 443
    to_port = 443
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"

}
resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
    security_group_id = aws_security_group.alb_sg.id

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"

}

#EC2 Security group allowing 80 traffic
resource "aws_security_group" "ec2_sg" {
    vpc_id = var.vpc_id
    tags = merge(
        var.common_tags,
        {
            Name = "${var.name_prefix}-ec2-sg"
        }
    )
  
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http" {
  security_group_id = aws_security_group.ec2_sg.id
  
  #Allow HTTP from ALB only
  referenced_security_group_id = aws_security_group.alb_sg.id

  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ec2_outbound" {
  security_group_id = aws_security_group.ec2_sg.id
  
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"

}

#RDS Security Group allowing 3306 traffic
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id
  
  tags = merge(
        var.common_tags,
        {
            Name = "${var.name_prefix}-rds-sg"
        }
    )
}

resource "aws_vpc_security_group_ingress_rule" "rds_mysql" {
  security_group_id = aws_security_group.rds_sg.id
  ip_protocol = "tcp"

#Allow traffic from EC2 only
referenced_security_group_id = aws_security_group.ec2_sg.id

from_port = 3306
to_port = 3306

}

resource "aws_vpc_security_group_egress_rule" "rds_outbound" {
  security_group_id = aws_security_group.rds_sg.id

  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}