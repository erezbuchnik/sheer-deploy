#!/bin/bash
set -x


if [ "${jdep_cmd}" != "$(readlink -e ${jdep_alias})" ]
then
        echo >&2 "Installing jdep."
	rm -rf ${jdep_install_path} ${jdep_alias}
	mkdir -p ${jdep_install_path}
        cp -r ./.internals ${jdep_install_path}/.internals
        install ./jdep ${jdep_install_path}/jdep
        ln -s ${jdep_install_path}/jdep ${jdep_alias}
fi


command -v jdep >/dev/null 2>&1 || { \
	echo >&2 "jdep installation failed. Please check permissions and Internet connection. Also try a fresh copy of the jdep repository."; \
	echo >&2 "Aborted."; \
	set +x; \
	exit 1; }


set +x



