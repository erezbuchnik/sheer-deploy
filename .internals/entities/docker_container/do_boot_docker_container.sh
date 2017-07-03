#!/bin/bash
set -x


function write_bootfile {

deploy_cfg_file_param=$1
container_name_param=$2

base_img=$(cat ${deploy_cfg_file_param} | jq -r ".${container_name_param}.base_img")
if [[ "$(docker images -q ${base_img} 2> /dev/null)" == "" ]]; then
	base_img_install_file=./${base_img}_install.sh
	echo "#!/bin/bash" > ${base_img_install_file}
	write_dockerfile ${deploy_cfg_file_param} ${base_img} > ./Dockerfile
fi

yum_dependencies=$(cat ${deploy_cfg_file_param} | jq -r ".${container_name_param}.yum")
if [[ ${yum_dependencies} != "null" ]]; then
	echo ${yum_dependencies} | jq -r " .[] | \"yum -y \(..)\""
fi

apt_dependencies=$(cat ${deploy_cfg_file_param} | jq -r ".${container_name_param}.apt")
if [[ ${apt_dependencies} != "null" ]]; then
	echo ${apt_dependencies} | jq -r " .[] | \"apt-get -y \(..)\""
fi

cat ${deploy_cfg_file_param} | jq -r ".${container_name_param}.boot_env | to_entries | map(\"\(.key)=\(.value|tostring)\"  ) | .[]"
cat ${deploy_cfg_file_param} | jq -r ".${container_name_param}.boot_sequence[]"

}


old_container=$(docker ps -aq --filter=name=${container_name})
docker kill ${old_container}
docker rm ${old_container}
rm -fr ./.boot_artifacts
mkdir -p ./.boot_artifacts
cd ./.boot_artifacts
echo "#!/bin/bash" > ./${container_name}_boot.sh
write_bootfile ${deploy_cfg_file} ${container_name} >> ./${container_name}_boot.sh
chmod +x ./${container_name_param}_boot.sh
base_img=$(cat ${deploy_cfg_file} | jq -r ".${container_name}.base_img")
docker_flags=$(cat ${deploy_cfg_file} | jq -r ".${container_name}.docker_flags")
exposed_tcp=$(cat ${deploy_cfg_file} | jq -r ".${container_name}.expose_tcp | to_entries | map(\"-p \(.value|tostring):\(.key)\"  ) | .[]")
docker build --tag ${base_img} ./
sleep 1
docker run --name=${container_name} \
${exposed_tcp} \
${docker_flags} \
-v `pwd`/${container_name}_boot.sh:/${container_name}_boot.sh \
${base_img} \
/bin/bash -c "/${container_name}_boot.sh"
cd -


set +x


