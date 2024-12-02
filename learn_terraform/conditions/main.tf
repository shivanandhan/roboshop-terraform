output "test"{

  value = var.x ==2 ? "yes true" : "not true"
}


variable "x"{
  default = 2
}