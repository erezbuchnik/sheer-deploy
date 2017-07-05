#!/bin/bash
set -x


function jdep_abort {

	abort_reason=$1
	jdep_msg_file=${jdep_install_path}/.internals/jdep/jdep_msg.json

	
}


if [ "${jdep_cmd}" != "${jdep_alias}" ]
then
        echo >&2 "Installing jdep."
	rm -rf ${jdep_install_path} ${jdep_alias}
        install -d ${jdep_install_path}/.internals
        install -D ./.internals/* ${jdep_install_path}/.internals
        install ./jdep ${jdep_install_path}/jdep
        ln -s ${jdep_install_path}/jdep ${jdep_alias}
fi


command -v jdep >/dev/null 2>&1 || { \
	echo >&2 "jdep installation failed. Please check permissions and Internet connection. Also try a fresh copy of the jdep repository."; \
	echo >&2 "Aborted."; \
	exit 1; }


set +x



