
resource "aws_dynamodb_table" "DynamoDB_Autoscaling_Table" {

  name = var.TableName
  hash_key = var.TableKeys.hash_key[0]
  range_key = length(var.TableKeys) == 2 ? var.TableKeys.range_key[0] : null

  billing_mode      = var.Capacity_Mode == "OD" ? "PAY_PER_REQUEST" : "PROVISIONED"
  read_capacity     = var.Capacity_Mode == "OD" ? null : var.ReadCapacity
  write_capacity    = var.Capacity_Mode == "OD" ? null : var.WriteCapacity

  stream_enabled    = var.Stream_Enabled
  stream_view_type  = var.Stream_Enabled == true ? var.StreamViewType : null

  dynamic "attribute" {
    for_each = var.TableKeys
    content {
      name = attribute.value[0]
      type = attribute.value[1]
    }

  }

  point_in_time_recovery {
    enabled = var.Point_In_Time_Recovery_Enabled
  }

  lifecycle {
    ignore_changes = ["read_capacity","write_capacity"]
  }
}

resource "aws_appautoscaling_target" "Read_AutoScalingTarget" {
  count              = var.Capacity_Mode == "OD" ? 0 : 1
  max_capacity       = var.ReadCapacity * var.ReadCapacityMaximumFactor
  min_capacity       = var.ReadCapacity
  resource_id        = "table/${var.TableName}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "Read_AutoScalingPolicy" {
  count              = var.Capacity_Mode == "OD" ? 0 : 1
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.Read_AutoScalingTarget.0.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.Read_AutoScalingTarget.0.resource_id
  scalable_dimension = aws_appautoscaling_target.Read_AutoScalingTarget.0.scalable_dimension
  service_namespace  = aws_appautoscaling_target.Read_AutoScalingTarget.0.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.ReadCapacityTargetUtilization
  }
}

resource "aws_appautoscaling_target" "Write_AutoScalingTarget" {
  count              = var.Capacity_Mode == "OD" ? 0 : 1
  max_capacity       = var.WriteCapacity * var.WriteCapacityMaximumFactor
  min_capacity       = var.WriteCapacity
  resource_id        = "table/${var.TableName}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "Write_AutoScalingPolicy" {
  count              = var.Capacity_Mode == "OD" ? 0 : 1
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.Write_AutoScalingTarget.0.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.Write_AutoScalingTarget.0.resource_id
  scalable_dimension = aws_appautoscaling_target.Write_AutoScalingTarget.0.scalable_dimension
  service_namespace  = aws_appautoscaling_target.Write_AutoScalingTarget.0.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.WriteCapacityTargetUtilization
  }
}
