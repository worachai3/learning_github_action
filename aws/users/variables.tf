variable "users" {
  type = list
  default = [
	{
	  name = "worachai"
	  age = 30
	},
	{
	  name = "worachai2"
	  age = 31
	}
  ]
}

variable application_name {
  default = "07-backend-state"
}

variable project_name {
  default = "users"
}

variable environment {
  default = "dev"
}