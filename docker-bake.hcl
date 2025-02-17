variable "TAG" {
  default = "v0.1.0"
}

group "default" {
  targets = ["elysia"]
}

target "elysia" {
  dockerfile = "Dockerfile"
  context = "."
  tags = ["hj212223/elysia:${TAG}"]
  platforms = ["linux/amd64"]
}