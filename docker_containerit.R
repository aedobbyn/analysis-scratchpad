library(containerit)

dockerfile_object <- dockerfile(from = utils::sessionInfo(),
                                image = "rocker/verse",
                                maintainer = c("amanda@earlybird.co",
                                               "developers@earlybird.co",
                                               "amanda.e.dobbyn@gmail.com"),
                                copy = c("/"),
                                save_image = FALSE,
                                add_self = TRUE,
                                versioned_libs = TRUE,
                                versioned_packages = TRUE,
                                cmd = Cmd('startup/load_packages.R'))  # so that we can run this at localhost

write(dockerfile_object, file = here::here("Dockerfile2"))
