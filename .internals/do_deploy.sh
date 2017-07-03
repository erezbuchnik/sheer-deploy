#!/bin/bash
set -x

deploy_cfg_file=$(readlink -e $1)

source ${deploy_framework_dir}/docker/do_install_docker.sh
source ${deploy_framework_dir}/kvm/do_install_kvm.sh
source ${deploy_framework_dir}/host/do_install_host.sh

source ${deploy_framework_dir}/docker/do_boot_docker.sh
source ${deploy_framework_dir}/kvm/do_boot_kvm.sh
source ${deploy_framework_dir}/host/do_boot_host.sh


set +x

