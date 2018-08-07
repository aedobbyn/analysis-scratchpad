library(stevedore)
library(containerit)

docker <- docker_client()

dockerfile_object <- dockerfile()

write(dockerfile_object, file = here::here("Dockerfile.txt"))
