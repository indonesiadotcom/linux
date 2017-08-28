apt update && apt install -y curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt install -y software-properties-common
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update && apt install -y docker-ce

