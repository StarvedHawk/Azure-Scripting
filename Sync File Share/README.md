# Azure-Scripting
Scripts that have been created for niche use cases azure




ubuntu Linux Setup Steps : 

    1  sudo apt remove azure-cli -y && sudo apt autoremove -y
    2  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    3  ls
    4  apt-get install git
    5  sudo apt-get install git
    6  git clone https://github.com/StarvedHawk/Azure-Scripting.git
    7  ls
    8  cd Azure-Scripting
    9  ls
   10  git pull
   11  git status
   12  ls
   13  cd Sync\ File\ Share/
   14  ls
   15  vim Sync-File-Share-DR.sh
   16  ls
   17  cd ..
   18  ls
   19  curl -sSL -O https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.rpm
   20  sudo rpm -i packages-microsoft-prod.rpm
   21  curl -sSL -O https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
   22  sudo dpkg -i packages-microsoft-prod.deb
   23  rm packages-microsoft-prod.deb
   24  sudo apt-get update
   25  sudo apt-get install azcopy
   37  az login
   38  az login -tenant
   45  chmod +x Sync-File-Share-DR.sh
   46  ./Sync-File-Share-DR.sh