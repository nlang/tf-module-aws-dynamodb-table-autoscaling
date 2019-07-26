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
  default = 0
}

variable "WriteCapacity" {
  type = "string"
  description = "Desired write capacity units. Put any value if capacity type is OD"
  default = 0
}

variable "ReadCapacityMaximumFactor" {
  type = "string"
  default = 10
  description = "This value multiplied by ReadCapacity will be the maximum auto scaling capacity"
}
variable "ReadCapacityTargetUtilization" {
  type = "string"
  default = 70
  description = "The target utilization for read capacity scaling activites"
}
variable "WriteCapacityMaximumFactor" {
  type = "string"
  default = 10
  description = "This value multiplied by WriteCapacity will be the maximum auto scaling capacity"
}
variable "WriteCapacityTargetUtilization" {
  type = "string"
  default = 70
  description = "The target utilization for write capacity scaling activites"
}
variable "Point_In_Time_Recovery_Enabled" {
  type = "string"
  default = false
  description = "Whether point in time recovery should be enabled (true/false)"
}
variable "Stream_Enabled" {
  type = "string"
  default = false
  description = "Whether dynamodb stream should be enabled (true/false)"
}
variable "StreamViewType" {
  type = "string"
  default = "NEW_AND_OLD_IMAGES"
}
