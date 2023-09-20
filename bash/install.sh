#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Whoa, Run this script as root.."
  exit
fi

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
    apt-add-repository ppa:ansible/ansible
    apt update -y
    apt install ansible -y
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

getting_update
ansible_setup
azure_cli
k8s_setup