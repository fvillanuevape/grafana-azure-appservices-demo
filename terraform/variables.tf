variable "mariadb_username" {
  type = string
  sensitive = true
  description = "Database Administrator Username"
}

variable "mariadb_password" {
  type = string
  sensitive = true
  description = "Database Administrator Password"
}