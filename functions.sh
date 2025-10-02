#!/bin/bash

print_logo() {
   echo -e "\033[1;33m
   ___  __  _ ____        _      __ 
  / _ |/ /_(_) __/_______(_)__  / /_
 / __ / __/ /\ \/ __/ __/ / _ \/ __/    Arch Linux System
/_/ |_\__/_/___/\__/_/ /_/ .__/\__/     by: Atineon
                        /_/         
   \033[0m"
}

print_message() {
   type="$1"
   section="$2"
   message="$3"

   if [[ "$type" == "ERROR" ]]; then
      echo -e "\033[1;31m[$(date '+%Y-%m-%d %H:%M:%S')] [$section] $message\033[0m" >&2
   elif [[ "$type" == "SUCCESS" ]]; then
      echo -e "\033[1;32m[$(date '+%Y-%m-%d %H:%M:%S')] [$section] $message\033[0m"
   else
      echo -e "\033[1;34m[$(date '+%Y-%m-%d %H:%M:%S')] [$section] $message\033[0m"
   fi
}

check_sudo() {
   if [[ "$(id -u)" -ne 0 ]]; then
      print_message "ERROR" "SCRIPT" "This script requires elevated privileges. Please run with sudo command."
      help
      exit 1
   fi
}

get_args() {
   if [[ "$#" -eq 0 ]]; then
      print_message "ERROR" "SCRIPT" "No parameters provided."
      help
      exit 0
   else
      while [[ "$#" -gt 0 ]]; do
         case $1 in
               -h | --help)
                  help
                  exit 0
               ;;
               -f | --full)
                  UPDATE=true
                  INSTALL_PACKAGE_MANAGER=true
                  INSTALL_PACKAGES=true
                  ENABLE_SERVICES=true
               ;;
               -p | --partial)
                  UPDATE=true
                  INSTALL_PACKAGE_MANAGER=true
               ;;
               -U | --update)
                  UPDATE=true
               ;;
               -M | --install-package-manager)
                  INSTALL_PACKAGE_MANAGER=true
               ;;
               -P | --install-packages)
                  INSTALL_PACKAGES=true
               ;;
               -S | --enable-services)
                  ENABLE_SERVICES=true
               ;;
               *)
                  print_message "ERROR" "SCRIPT" "Unknown parameter passed: $1"
                  help
                  exit 1
               ;;
         esac
         shift
      done
   fi
}

help() {
   echo -e "\033[1;34mUsage: sudo $0 [options]"
   echo "Options:"
   echo "  -h, --help                     Display this help message"
   echo "  -f, --full                     Perform a full setup (update system, install package manager, install packages, enable services)"
   echo "  -p, --partial                  Perform a partial setup (update system, install package manager)"
   echo "  -U, --update                   Update the system"
   echo "  -M, --install-package-manager  Install the AUR package manager (yay)"
   echo "  -P, --install-packages         Install all packages listed in packages.conf"
   echo -e "  -S, --enable-services          Enable services listed in packages.conf\033[0m"
}

update_system() {
   print_message "INFO" "SYSTEM UPDATE" "Updating system..."
   sudo pacman -Syu --noconfirm
}

install_package_manager() {
   print_message "INFO" "YAY INSTALL" "Checking if yay AUR helper is installed..."
   if ! command -v yay &> /dev/null; then
      if [[ ! -d "yay" ]]; then
         print_message "INFO" "YAY INSTALL" "yay AUR helper not found..."
         print_message "INFO" "YAY INSTALL" "Cloning the repository..."
      else
         print_message "INFO" "YAY INSTALL" "yay directory already exists, removing it..."
         rm -rf yay
      fi
      git clone https://aur.archlinux.org/yay.git
      cd yay
      print_message "INFO" "YAY INSTALL" "building yay package..."
      makepkg -si --noconfirm
      cd ..
      rm -rf yay
   else
      print_message "INFO" "YAY INSTALL" "yay is already installed"
   fi
}

install_packages() {
   packages=("$@")
   
   print_message "INFO" "PACKAGE INSTALL" "Installing packages..."
   if [[ -f "packages.conf" ]]; then
      for package in "${packages[@]}"; do
         print_message "INFO" "PACKAGE INSTALL" "Processing package: $package"
         if ! pacman -Qi "$package" &> /dev/null && ! pacman -Qg "$package" &> /dev/null && ! yay -Qi "$package" &> /dev/null && ! yay -Qg "$package" &> /dev/null; then
            print_message "INFO" "PACKAGE INSTALL" "Installing $package..."
            yay -S --noconfirm "$package"
         else
            print_message "INFO" "PACKAGE INSTALL" "$package is already installed"
         fi
      done
   else
      print_message "ERROR" "PACKAGE INSTALL" "packages.conf file not found!"
      exit 1
   fi
}

enable_services() {
   services=("$@")
   
   print_message "INFO" "SERVICE MANAGEMENT" "Enabling services..."
   for service in "${services[@]}"; do
      print_message "INFO" "SERVICE MANAGEMENT" "Processing service: $service..."
      if ! systemctl list-unit-files | grep -qw "$service"; then
         print_message "ERROR" "SERVICE MANAGEMENT" "Service $service does not exist!"
         continue
      fi
      if ! systemctl is-enabled --quiet "$service"; then
         print_message "INFO" "SERVICE MANAGEMENT" "Enabling $service..."
      else
         print_message "INFO" "SERVICE MANAGEMENT" "$service is already enabled."
         continue
      fi
      sudo systemctl enable "$service"
   done
}

print_end_message() {
   print_message "SUCCESS" "SCRIPT" "Setup complete! You may want to reboot your system."
}