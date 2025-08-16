#!/bin/bash
# Script corrigé pour LineageOS dans QEMU

set -euo pipefail

# Configuration
IMAGE_URL="https://ia601205.us.archive.org/5/items/lineage-os-v-17.1-android-x-86-64-202009091904-k-kernel-5.8-si-next-rmi-m-lineag/LineageOS_v17.1-android_x86_64-202009091904_k-kernel-5.8-si-next-rmi_m-lineage-17.1_dgc-q-x86-generic_gms_cros-hd_cros-wv.iso"
WORK_DIR="$PWD/lineageos_vm"
mkdir -p "$WORK_DIR"
DATA_DISK="$WORK_DIR/android-data.qcow2"

# ================= VÉRIFICATIONS =================
check_deps() {
    local missing=()
    for dep in qemu-system-x86_64 curl qemu-img; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "❌ Dépendances manquantes: ${missing[*]}"
        echo "Installez avec: sudo apt install ${missing[*]}"
        exit 1
    fi
}

# ================= TÉLÉCHARGEMENT =================
download_image() {
    if [ ! -f "$WORK_DIR/lineageos.iso" ]; then
        echo "➤ Téléchargement de LineageOS..."
        curl -L "$IMAGE_URL" -o "$WORK_DIR/lineageos.iso" --progress-bar || {
            echo "❌ Échec du téléchargement"
            exit 1
        }
    fi
}

# ================= PRÉPARATION DISQUE =================
prepare_disk() {
    if [ ! -f "$DATA_DISK" ]; then
        echo "➤ Création du disque de données (32G)..."
        qemu-img create -f qcow2 "$DATA_DISK" 32G
    fi
}

# ================= DÉMARRAGE QEMU =================
start_qemu() {
    local qemu_cmd=(
        "qemu-system-x86_64"
        "-m" "4G"
        "-smp" "4"
        "-enable-kvm"
        "-cpu" "host"
        "-cdrom" "$WORK_DIR/lineageos.iso"
        "-drive" "file=$DATA_DISK,if=virtio,format=qcow2"
        "-vga" "virtio"
        "-display" "gtk,gl=on"
        "-net" "nic,model=virtio"
        "-net" "user,hostfwd=tcp::5555-:5555"
        "-usb"
        "-device" "usb-tablet"
        "-machine" "q35,accel=kvm"
    )
    
    echo "➤ Démarrage de LineageOS avec:"
    printf "  %s\n" "${qemu_cmd[@]}"
    "${qemu_cmd[@]}"
}

# ================= MAIN =================
check_deps
download_image
prepare_disk
start_qemu

echo "✅ LineageOS devrait maintenant démarrer !"