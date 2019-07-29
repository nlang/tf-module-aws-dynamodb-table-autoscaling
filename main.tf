
resource "aws_dynamodb_table" "DynamoDB_Autoscaling_Table" {

  name = var.TableName
  hash_key = var.TableKeys.hash_key.name
  range_key = var.TableKeys.range_key != null ? var.TableKeys.range_key.name : null

  billing_mode      = var.CapacityMode == "OD" ? "PAY_PER_REQUEST" : "PROVISIONED"
  read_capacity     = var.CapacityMode == "OD" ? null : var.ReadCapacity
  write_capacity    = var.CapacityMode == "OD" ? null : var.WriteCapacity

  stream_enabled    = var.Stream_Enabled
  stream_view_type  = var.Stream_Enabled == true ? var.StreamViewType : null

  dynamic "attribute" {
    for_each = var.TableKeys
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  point_in_time_recovery {
    enabled = var.PointInTimeRecoveryEnabled
  }

  lifecycle {
    ignore_changes = ["read_capacity","write_capacity"]
  }

  ttl {
    enabled = var.TtlAttribute != null ? true : false
    attribute_name = var.TtlAttribute != null ? var.TtlAttribute : ""
  }

  dynamic "local_secondary_index" {
    for_each = var.LocalSecondaryIndex
    content {
      name = local_secondary_index.value.name
      projection_type = local_secondary_index.value.projection_type
      range_key = local_secondary_index.value.range_key
      non_key_attributes = contains(keys(local_secondary_index.value), "non_key_attributes") ? local_secondary_index.value.non_key_attributes : null
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.GlobalSecondaryIndex
    content {
      name = global_secondary_index.value.name
      hash_key = global_secondary_index.value.hash_key
      range_key = global_secondary_index.value.range_key
      projection_type = global_secondary_index.value.projection_type
      read_capacity = var.CapacityMode != "OD" ? global_secondary_index.value.read_capacity : null
      write_capacity = var.CapacityMode != "OD" ? global_secondary_index.value.write_capacity : null
      non_key_attributes = contains(keys(global_secondary_index.value), "non_key_attributes") ? global_secondary_index.value.non_key_attributes : null
    }
  }

  tags = var.Tags
}

resource "aws_appautoscaling_target" "Read_AutoScalingTarget" {
  count              = var.CapacityMode == "OD" ? 0 : 1
  max_capacity       = var.ReadCapacity * var.ReadCapacityMaximumFactor
  min_capacity       = var.ReadCapacity
  resource_id        = "table/${var.TableName}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "Read_AutoScalingPolicy" {
  count              = var.CapacityMode == "OD" ? 0 : 1
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
  count              = var.CapacityMode == "OD" ? 0 : 1
  max_capacity       = var.WriteCapacity * var.WriteCapacityMaximumFactor
  min_capacity       = var.WriteCapacity
  resource_id        = "table/${var.TableName}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "Write_AutoScalingPolicy" {
  count              = var.CapacityMode == "OD" ? 0 : 1
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
