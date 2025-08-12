#!/usr/bin/env bash

# ==========================================================
# Fedora Setup Script - Instalador pessoal do SAM
# ==========================================================

set -e  # Se der erro, o script para

# ---- Funções utilitárias ----
info()    { echo -e "\e[34m[INFO]\e[0m $1"; }
success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
error()   { echo -e "\e[31m[ERROR]\e[0m $1"; }

# ---- Atualiza sistema ----
update_system() {
    info "Atualizando sistema..."
    sudo dnf upgrade --refresh -y
    success "Sistema atualizado."
}

# ---- Instala pacotes DNF ----
install_dnf_packages() {
    info "Instalando pacotes via DNF..."
    PACKAGES=(
        helix
        zoxide
        dotnet-sdk-9.0
        gh
        cmatrix
        cbonsai
        nsnake
    )

    sudo dnf install -y "${PACKAGES[@]}"
    success "Pacotes DNF instalados."
}

# ---- Configura zoxide no .zshrc ----
configure_zoxide() {
    info "Configurando zoxide no ~/.zshrc..."

    if ! grep -q 'eval "$(zoxide init zsh)"' "$HOME/.zshrc"; then
        echo '' >> "$HOME/.zshrc"
        echo '# Inicialização do zoxide' >> "$HOME/.zshrc"
        echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
        success "zoxide adicionado ao ~/.zshrc."
    else
        info "zoxide já está configurado no ~/.zshrc."
    fi
}

# ---- Copia wallpapers para ~/Pictures ----
install_wallpapers() {
    SRC_DIR="$(dirname "$0")/wallpapers"
    DEST_DIR="$HOME/Pictures"

    if [ -d "$SRC_DIR" ]; then
        info "Copiando pasta wallpapers..."
        mkdir -p "$DEST_DIR"
        cp -r "$SRC_DIR" "$DEST_DIR"
        success "Pasta wallpapers copiada para $DEST_DIR."
    else
        info "Nenhuma pasta 'wallpapers' encontrada no diretório do script."
    fi
}

# ---- Copia config do helix para ~/.config ----
install_helix_config() {
    SRC_DIR="$(dirname "$0")/helix"
    DEST_DIR="$HOME/.config"

    if [ -d "$SRC_DIR" ]; then
        info "Copiando pasta helix..."
        mkdir -p "$DEST_DIR"
        cp -r "$SRC_DIR" "$DEST_DIR"
        success "Pasta helix copiada para $DEST_DIR."
    else
        info "Nenhuma pasta 'helix' encontrada no diretório do script."
    fi
}

# ---- Execução ----
update_system
install_dnf_packages
configure_zoxide
install_wallpapers
install_helix_config

info "Setup finalizado!"

