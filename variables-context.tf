variable "context" {
  description = "Provides standardized naming policy and attribute information for data source reference to define cloud resources for a Project."
  type        = object({
    project     = string
    name_prefix = string
    tags        = map(string)
  })
}
