# Terraform module for dynamodb

Creates a table with on-demand billing or provisioned capacity with autoscaling enabled

## Examples

### Simple autoscaling

```hcl
module "some_table" {

  source = "github.com/nlang/tf-module-aws-dynamodb-table-autoscaling"

  TableName = "myNewTable"
  TableKeys = { hash_key = ["fooKey", "S"], range_key = ["barKey", "S"] }

  Capacity_Mode = "PR"
  ReadCapacity = 25
  WriteCapacity = 10
}

```

### Simple on-demand
```hcl
module "some_other_table" {

  source = "github.com/nlang/tf-module-aws-dynamodb-table-autoscaling"

  TableName = "myOtherNewTable"
  TableKeys = { hash_key = ["MyId", "N"] }

  Capacity_Mode = "OD"
}

```

### More options autoscaling
```hcl
module "the_third_table" {

  source = "github.com/nlang/tf-module-aws-dynamodb-table-autoscaling"

  TableName = "myThirdTable"
  TableKeys = { hash_key = ["MyId", "N"] }

  Capacity_Mode = "PR"
  
  ReadCapacity = 25
  ReadCapacityMaximumFactor = 10
  ReadCapacityTargetUtilization = 60
  
  WriteCapacity = 10
  WriteCapacityMaximumFactor = 15
  WriteCapacityTargetUtilization = 50
  
  Point_In_Time_Recovery_Enabled = true
  
  Stream_Enabled = true
  StreamViewType = "NEW_AND_OLD_IMAGES"
}

```

### GSI, LSI, TTL
```hcl
module "a_more_complex_table" {

  source = "github.com/nlang/tf-module-aws-dynamodb-table-autoscaling"

  TableName = "tableWithLSIandGSI"
  TableKeys = {
    hash_key = { name: "hashKey", type: "S" },
    range_key = { name: "rangeKey", type: "S" },
    lsi_range_key = { name: "lsiRangeKey", type: "S" },
    gsiHashKey = { name: "gsiHashKey", type: "S" },
    gsiRangeKey = { name: "gsiRangeKey", type: "S" },
  }

  Capacity_Mode = "OD"
  TTL_Attribute = "expirationTimeEpoch"
  
  Local_Secondary_Index = [{
    name = "myLSI"
    projection_type = "KEYS_ONLY"
    range_key = "lsiRangeKey"
  }]

  Global_Secondary_Index = [{
    name = "MyGSI"
    hash_key = "gsiHashKey"
    range_key = "gsiRangeKey"
    projection_type = "ALL"
  }]

}
```

## Author

Written by [Nicolai Lang](https://github.com/nlang)

## License

MIT License
