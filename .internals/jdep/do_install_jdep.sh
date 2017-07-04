#!/bin/bash
set -x


command -v ${jdep_name} >/dev/null 2>&1 || { \
        echo >&2 "Installing ${jdep_name}."; \
        install -d ${jdep_install_path}/.internals; \
        install -D ./.internals/* ${jdep_install_path}/.internals; \
        install ./jdep.sh ${jdep_install_path}/jdep; \
        ln -s ${jdep_install_path}/jdep.sh ${jdep_alias}; }
command -v ${jdep_name} >/dev/null 2>&1 || { echo >&2 "${jdep_name} failed to install. Aborting."; exit 1; }


set +x



