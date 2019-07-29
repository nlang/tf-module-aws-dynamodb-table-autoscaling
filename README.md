# Terraform module for dynamodb

Creates a table with on-demand billing or provisioned capacity with autoscaling enabled

## Examples

### Simple autoscaling

```hcl
module "some_table" {

  source = "github.com/nlang/tf-module-aws-dynamodb-table-autoscaling"

  TableName = "myNewTable"
  TableKeys = { hash_key = ["fooKey", "S"], range_key = ["barKey", "S"] }

  CapacityMode = "PR"
  ReadCapacity = 25
  WriteCapacity = 10

  Tags = {
    "SomeTag": "A Tag Value"
    "AnotherTag": 42
  }
}

```

### Simple on-demand
```hcl
module "some_other_table" {

  source = "github.com/nlang/tf-module-aws-dynamodb-table-autoscaling"

  TableName = "myOtherNewTable"
  TableKeys = { hash_key = ["MyId", "N"] }

  CapacityMode = "OD"
}

```

### More options autoscaling
```hcl
module "the_third_table" {

  source = "github.com/nlang/tf-module-aws-dynamodb-table-autoscaling"

  TableName = "myThirdTable"
  TableKeys = { hash_key = ["MyId", "N"] }

  CapacityMode = "PR"
  
  ReadCapacity = 25
  ReadCapacityMaximumFactor = 10
  ReadCapacityTargetUtilization = 60
  
  WriteCapacity = 10
  WriteCapacityMaximumFactor = 15
  WriteCapacityTargetUtilization = 50
  
  PointInTimeRecoveryEnabled = true
  
  StreamEnabled = true
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

  CapacityMode = "OD"
  TtlAttribute = "expirationTimeEpoch"
  
  LocalSecondaryIndex = [{
    name = "myLSI"
    projection_type = "KEYS_ONLY"
    range_key = "lsiRangeKey"
  }]

  GlobalSecondaryIndex = [{
    name = "MyGSI"
    hash_key = "gsiHashKey"
    range_key = "gsiRangeKey"
    projection_type = "ALL"
  }]

}
```

## Output
| **Parameter**           | **Description**                                |
| :---------------------- | :--------------------------------------------- |
| `TableArn`              | `(string)` ARN of the created table            |
| `TableName`             | `(string)` Name of the created table           |
| `DynamoStreamEnabled`   | `(bool)` whether streams are enabled or not    |
| `DynamoStreamArn`       | `(string)` ARN of the stream, if enabled       |
| `DynamoStreamViewType`  | `(string)` View type if the stream, if enabled |

## Author

Written by [Nicolai Lang](https://github.com/nlang)

## License

MIT License
