output "TableArn" {
  value = aws_dynamodb_table.DynamoDB_Autoscaling_Table.arn
}
output "TableName" {
  value = aws_dynamodb_table.DynamoDB_Autoscaling_Table.name
}
output "DynamoStreamEnabled" {
  value = aws_dynamodb_table.DynamoDB_Autoscaling_Table.stream_enabled
}
output "DynamoStreamArn" {
  value = aws_dynamodb_table.DynamoDB_Autoscaling_Table.stream_arn
}
output "DynamoStreamViewType" {
  value = aws_dynamodb_table.DynamoDB_Autoscaling_Table.stream_view_type
}
