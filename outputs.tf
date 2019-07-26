output "TableARN" {
  value = aws_dynamodb_table.DynamoDB_Autoscaling_Table.arn
}
output "TableName" {
  value = aws_dynamodb_table.DynamoDB_Autoscaling_Table.name
}
output "Table" {
  value = ""
}
