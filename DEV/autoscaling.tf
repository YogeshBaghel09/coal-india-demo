provider "aws" {
region = "ap-south-1"
}
resource "aws_launch_configuration" "Hitachi-DEV" {
  #name_prefix = "Hitachi-DEV"
   name = "Hitachi-DEV-LC"
  image_id = "ami-05c8ca4485f8b138a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3a.micro"
  iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
  key_name = "Coal-India-Jenkins-Server-Key"
  #security_groups = ["sg-0f26eebf1b3476c10"]
  security_groups = [aws_security_group.Hitachi-DEV.id]
    root_block_device {
    #device_name = "/dev/xvdb"
    volume_type = "gp3"
    volume_size = 10
	encrypted   = true
	#kms_key_id  =  "arn:aws:kms:ap-south-1:371348661740:key/918670b8-f7a8-4c71-8ac2-d946da0de843"
	delete_on_termination = true
  }
   user_data = "${file("hitachi.sh")}"
}
resource "aws_autoscaling_group" "Hitachi-DEV" {
  name = "Hitachi-DEV-ASG"
  min_size             = 2
  desired_capacity     = 2
  max_size             = 2

  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.Hitachi-DEV.name
  # target_group_arns = [aws_lb_target_group.Hitachi-DEV-tg.arn]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
    "subnet-06a0cfa8ecd1ae2c4",
    "subnet-023f1d68d0e8e82fc"
  ]
  #vpc_zone_identifier = ["${aws_subnet.cidr_private_subnet_a.id}"]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
tags = [
  {
    "key" = "Name"
    "value" = "Hitachi-DEV"
    "propagate_at_launch" = true
  },
  {
    "key" = "Environment"
    "value" = "DEV"
    "propagate_at_launch" = true
	},
	{
    "key" = "Application Name"
    "value" = "Webserver"
    "propagate_at_launch" = true
	},
	{
    "key" = "Cost Center"
    "value" = "DEVuction"
    "propagate_at_launch" = true
	},
	{
    "key" = "Backup Retention"
    "value" = "yes"
    "propagate_at_launch" = true
	},
	{
    "key" = "Partner Name"
    "value" = "Hitachi"
    "propagate_at_launch" = true
	},
	{
    "key" = "Department"
    "value" = "Infra"
    "propagate_at_launch" = true
	},
    ]

}

resource "aws_autoscaling_policy" "Hitachi-DEV-UAT_Memory_Scale_UP" {
  name = "Hitachi-DEV-UAT_Memory_Scale_UP"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.Hitachi-DEV.name
}

resource "aws_cloudwatch_metric_alarm" "Hitachi-DEV-UAT_Memory_alarm_Scale_UP" {
  alarm_name = "Hitachi-DEV-UAT_Memory_alarm_Scale_UP"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "MemoryUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Hitachi-DEV.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.Hitachi-DEV-UAT_Memory_Scale_UP.arn ]
}



resource "aws_autoscaling_policy" "Hitachi-DEV-UAT_CPU_Scale_UP" {
  name = "Hitachi-DEV-UAT_CPU_Scale_UP"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.Hitachi-DEV.name
}

resource "aws_cloudwatch_metric_alarm" "Hitachi-DEV-UAT_CPU_alarm_Scale_UP" {
  alarm_name = "Hitachi-DEV-UAT_CPU_alarm_Scale_UP"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Hitachi-DEV.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.Hitachi-DEV-UAT_CPU_Scale_UP.arn ]
}

resource "aws_autoscaling_policy" "Hitachi-DEV-UAT_CPU_Scale_DOWN" {
  name = "Hitachi-DEV-UAT_CPU_Scale_DOWN"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.Hitachi-DEV.name
}

resource "aws_cloudwatch_metric_alarm" "Hitachi-DEV-UAT_CPU_alarm_Scale_DOWN" {
  alarm_name = "Hitachi-DEV-UAT_CPU_alarm_Scale_DOWN"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Hitachi-DEV.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.Hitachi-DEV-UAT_CPU_Scale_DOWN.arn ]
}


resource "aws_autoscaling_policy" "Hitachi-DEV-UAT_Memory_Scale_DOWN" {
  name = "Hitachi-DEV-UAT_Memory_Scale_DOWN"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.Hitachi-DEV.name
}

resource "aws_cloudwatch_metric_alarm" "Hitachi-DEV-UAT_Memory_alarm_Scale_DOWN" {
  alarm_name = "Hitachi-DEV-UAT_Memory_alarm_Scale_DOWN"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "MemoryUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Hitachi-DEV.name
  }

  alarm_description = "This metric monitor EC2 instance Memory utilization"
  alarm_actions = [ aws_autoscaling_policy.Hitachi-DEV-UAT_Memory_Scale_DOWN.arn ]
}

resource "aws_lb_target_group" "Hitachi-DEV-TG" {
  name     = "Hitachi-DEV-TG"
  port     = 80
 protocol = "HTTP"
  vpc_id   = "vpc-0258ea71d4876575b"
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb" "lb_hitachi-dev" {
  name               = "hitachi-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    "subnet-06a0cfa8ecd1ae2c4",
    "subnet-023f1d68d0e8e82fc"
  ]
  security_groups    = ["${aws_security_group.Hitachi-DEV.id}"]
  enable_deletion_protection = false
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "IB-API" {
  #listener_arn = "arn:aws:elasticloadbalancing:ap-south-1:476827303802:listener/app/IM-VER-DEV-LB/2687b802eb738bb3/0ce6499695b0b72c"
  #priority     = 15
  load_balancer_arn = "${aws_lb.lb_hitachi-dev.arn}"
  port = "80"
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Hitachi-DEV-TG.arn
  }

}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
 autoscaling_group_name = aws_autoscaling_group.Hitachi-DEV.id
 alb_target_group_arn = aws_lb_target_group.Hitachi-DEV-TG.arn
}
