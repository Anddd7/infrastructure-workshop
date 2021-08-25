# define a variable
# can be replaced in cli via '-var <variable name>=<new value>' 
variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}
