# Terraform module for dynamodb

Creates a table with on-demand billing or provisioned capacity with autoscaling enabled

## Examples

### Simple autoscaling

```hcl

module "some_table" {

  source = "git@github.com/nlang/tf-module-aws-dynamodb-table-autoscaling.git"

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

  source = "git@github.com/nlang/tf-module-aws-dynamodb-table-autoscaling.git"

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

## Author

Written by [Nicolai Lang](https://github.com/nlang)

## License

MIT License
