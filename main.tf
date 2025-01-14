terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
  }

  backend "remote" {
    organization = "sfguide_terraform_sample"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "snowflake" {
}

resource "snowflake_database" "db" {
  name = "TF_DEMO"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "TF_DEMO"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}


resource "snowflake_role" "role" {
  
  name     = "TF_DEMO_SVC_ROLE"
}

resource "snowflake_grant" "database_grant" {
  database_name = "TF_DEMO"
  privilege     = "USAGE"
  roles         = ["TF_DEMO_SVC_ROLE"]
}

resource "snowflake_schema" "schema" {
  database   = snowflake_database.db.name
  name       = "TF_DEMO"
  is_managed = false
}


resource "snowflake_grant" "schema_grant" {
  database_name = "TF_DEMO"
  schema_name   = "TF_DEMO"
  privilege     = "USAGE"
  roles         = ["TF_DEMO_SVC_ROLE"]
}


