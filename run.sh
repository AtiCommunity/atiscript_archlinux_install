#!/bin/bash

###########
# Sources #
###########

source functions.sh
source packages.conf

#####################
# Script parameters #
#####################

set -e

UPDATE=false
INSTALL_PACKAGE_MANAGER=false
INSTALL_PACKAGES=false
ENABLE_SERVICES=false

##########
# Script #
##########

clear
print_logo
check_sudo
get_args "$@"
if [[ "$UPDATE" == true ]]; then
    update_system
fi
if [[ "$INSTALL_PACKAGE_MANAGER" == true ]]; then
    install_package_manager
fi
if [[ "$INSTALL_PACKAGES" == true ]]; then
    install_packages "${SYSTEM[@]}"
    install_packages "${DESKTOP[@]}"
    install_packages "${FONTS[@]}"
fi
if [[ "$ENABLE_SERVICES" == true ]]; then
    enable_services "${SERVICES[@]}"
fi
print_end_message
