# Bliss_Os_QEMU-
Bliss Os on UBUNTU 

# DEPENDENCES REQUIREMENTS

    sudo apt update
    sudo apt install -y qemu-system-x86 qemu-utils curl
    sudo apt install -y virt-manager libvirt-daemon-system  # Pour KVM

# ACTIVATE KVM

    sudo kvm-ok

# Si nécessaire, ajoutez votre utilisateur au groupe kvm :

    sudo usermod -aG kvm $USER
    



# RUN

    chmod +x start_android_bin.sh
    ./start_android_bin.sh


<img width="1920" height="1080" alt="Screenshot from 2025-08-16 15-10-13" src="https://github.com/user-attachments/assets/d09139ba-5433-44fc-bcef-a2bc17d66733" />


# Supprimer le disque virtuel :

bash

    rm lineageos_vm/android-data.qcow2

# Recréer un disque vierge :

bash

    qemu-img create -f qcow2 lineageos_vm/android-data.qcow2 32G


By Gleaphe 2025 .
