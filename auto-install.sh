apt-get install $(grep -vE "^\s*#" aptreqs  | tr "\n" " ") # thank you http://askubuntu.com/questions/252734/apt-get-mass-install-packages-from-a-file
apt-get install pip
pip install -r pipreqs
