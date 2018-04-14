# # # HOW NOT TO INSTALL PACKAGES # # # 

# Jim Hester wisdom
# Packages are unfortunately not guaranteed to work across minor versions of R e.g.  3.3 -> 3.4, so to be safe you should probably reinstall them rather than copying them
# This is a pain I know :disappointed: but you can do `install.packages(dir_ls(old_path), Ncpus = 6)` or something like that




# install.packages("stringr")
# install.packages("fs")
# install.packages("purrr")

library(fs)
library(stringr)
library(purrr)

old_path <- "/Library/Frameworks/R.framework/Versions/3.3/Resources/library/"
new_path <- "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/"

all_pkgs <- dir_ls(old_path) %>% 
  str_replace_all(old_path, "")
base_pkgs <- dir_ls(new_path) %>% 
  str_replace_all(new_path, "")

to_port <- setdiff(all_pkgs, base_pkgs)

to_port_paths <- old_path %>% str_c(to_port)

to_port_paths %>% map(dir_copy, new_path = new_path)




