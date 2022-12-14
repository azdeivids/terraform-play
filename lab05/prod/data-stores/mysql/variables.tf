variable "db_username" {
  description = "MySQL DB Username"
  type        = string
  sensitive   = true
}
variable "db_password" {
  description = "MySQL DB User password"
  type        = string
  sensitive   = true
}


#####   We can pass the db_username and db_password using environemnt variables
##  Set the variables for linux/macOS

#   export TF_VAR_db_username=deivids
#   export TF_VAR_db_password=AdminPassword1

###     Use set instead of export when on Windows system

## you can echo the env variables to view the stored values like so
###### echo $TF_VAR_db_username

## in pwsh you can use just the dollar signe like so $TF_VAR_db_username