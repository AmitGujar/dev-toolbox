#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Whoa, Run this script as root.."
  exit
fi

git_auth(){
    git config --global user.name "AmitGujar"
    git config --global user.email "amithero3342@gmail.com"
    echo "setting up the wsl auth"
    local auth
    auth=$(git config --global credential.helper "/mnt/c/Users/AmitDilipGujar/AppData/Local/Programs/Git/mingw64/libexec/git-core/git-credential-wincred.exe")
    if [ -z "$auth" ]; then
        echo "Auth failed"
    else
        echo "Auth Success"
    fi
}

check_userinputforauth() {
    read -p "Do you want to configure the git with wsl = " configure

    if [ -z "$configure" ]; then 
        echo "All right, Nothing to do here....."
    else 
        git_auth
    fi
}


echo "Installing required tools....."

getting_update() {
    echo "Updating the system....."
    apt update -y
    wait
    apt upgrade -y
}

ansible_setup() {
    echo "Installing ansible....."
    apt install python3.10 -y
    apt install python3-pip -y
    wait
    echo -e "\n" | apt-add-repository ppa:ansible/ansible
    apt update -y
    apt install ansible -y
    echo "Checking for git"
    if command -v git &> /dev/null; then
        echo "git validation passed.."
    else
        apt install git -y
        sleep 3
    fi
    echo "Installing ansible linter...."
    pip3 install ansible-lint
}

azure_cli() {
    if command -v curl &> /dev/null; then
        echo "curl validation passed.."
    else
        apt install curl -y
        sleep 3
    fi
    echo "Installing Az CLI....."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    pip3 install -r /usr/lib/python3/dist-packages/ansible_collections/azure/azcollection/requirements-azure.txt
}

k8s_setup() {
    echo "Installing kubectl....."
    az aks install-cli
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}


terraform_install() {
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
}

check_userinputforauth
getting_update
ansible_setup
azure_cli
k8s_setup
terraform_install