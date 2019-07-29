variable "TableName" {
  type = "string"
  description = "The name of the table"
}

variable "TableKeys" {
  type = "map"
  description = "The keys (partition key and optional range key) as name/type tupel. E.g. { hash_key = ['foo', 'S'], range_key = ['bar', 'N'] }"
}

variable "Capacity_Mode" {
  type = "string"
  description = "The capacity mode OD = On-Demand, PR = Provisioned"
}

variable "ReadCapacity" {
  type = "string"
  description = "Desired read capacity units. Put any value if capacity type is OD"
}

variable "WriteCapacity" {
  type = "string"
  description = "Desired write capacity units. Put any value if capacity type is OD"
}

variable "ReadCapacityMaximumFactor" {
  type = "string"
  default = 10
  description = "(Optional) This value multiplied by ReadCapacity will be the maximum auto scaling capacity. Defaults to 10."
}
variable "ReadCapacityTargetUtilization" {
  type = "string"
  default = 70
  description = "(Optional) The target utilization for read capacity scaling activites. Defaults to 70."
}
variable "WriteCapacityMaximumFactor" {
  type = "string"
  default = 10
  description = "(Optional) This value multiplied by WriteCapacity will be the maximum auto scaling capacity. Defaults to 10."
}
variable "WriteCapacityTargetUtilization" {
  type = "string"
  default = 70
  description = "(Optional) The target utilization for write capacity scaling activites. Defaults to 70."
}
variable "Point_In_Time_Recovery_Enabled" {
  type = "string"
  default = false
  description = "(Optional) Whether point in time recovery should be enabled (true/false). Defaults to false."
}
variable "Stream_Enabled" {
  type = "string"
  default = false
  description = "(Optional) Whether dynamodb stream should be enabled (true/false). Defaults to false."
}
variable "StreamViewType" {
  type = "string"
  default = "NEW_AND_OLD_IMAGES"
  description = "(Optional) The stream view type for the DynamoDb stream. Possible values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE and NEW_AND_OLD_IMAGES. Defaults to NEW_AND_OLD_IMAGES."
}

variable "Local_Secondary_Index" {
  type = "list"
  default = []
  description = "(Optional) Local Secondary index definition as array of LSI configurations (see Terraform documentation for details)"
}

variable "Global_Secondary_Index" {
  type = "list"
  default = []
  description = "(Optional) Global Secondary index definition as array of GSI configurations (see Terraform documentation for details)"
}

variable "TTL_Attribute" {
  type = "string"
  default = null
  description = "(Optional) Set attribute name to enable TTL. Defaults to null => TTL disabled"
}

variable "Tags" {
  type = "map"
  default = {}
  description = "(Optional) Tags (key/value pairs)"
}
