# -----------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# -----------------------------------------------------------

variable "module_db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "module_db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

# -----------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# -----------------------------------------------------------

variable "module_db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_database_stage"
}

