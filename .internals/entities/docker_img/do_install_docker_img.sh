#!/bin/bash
set -x


function write_dockerfile {

json_deploy_file_param=$1
img_name_param=$2

base_img=$(cat ${json_deploy_file_param} | jq -r ".${img_name_param}.base_img")
docker pull ${base_img}
if [[ "$(docker images -q ${base_img} 2> /dev/null)" == "" ]]; then
	base_img_install_file=./${base_img}_install.sh
	echo "#!/bin/bash" > ${base_img_install_file}
	write_dockerfile ${json_deploy_file_param} ${base_img}
else
	echo FROM ${base_img} > ./Dockerfile
	echo "COPY resolv.conf /etc/resolv.conf" >> ./Dockerfile
fi

img_name_param=$2

yum_dependencies=$(cat ${json_deploy_file_param} | jq -r ".${img_name_param}.yum")
if [[ ${yum_dependencies} != "null" ]]; then
	echo "RUN yum -y install deltarpm" >> ./Dockerfile
	echo "RUN yum -y update" >> ./Dockerfile
	cat ${json_deploy_file_param} | jq -r ".${img_name_param}.yum | .[] | \"RUN yum -y \(..)\"" >> ./Dockerfile
fi

apt_dependencies=$(cat ${json_deploy_file_param} | jq -r ".${img_name_param}.apt")
if [[ ${apt_dependencies} != "null" ]]; then
	echo "RUN apt-get -y update" >> ./Dockerfile
	echo "RUN apt-get -y install apt-utils" >> ./Dockerfile
	echo "RUN apt-get -y install sudo" >> ./Dockerfile
	cat ${json_deploy_file_param} | jq -r ".${img_name_param}.apt | .[] | \"RUN apt-get -y \(..)\"" >> ./Dockerfile
fi

cat ${json_deploy_file_param} | jq -r ".${img_name_param}.install_env | to_entries | map(\"\(.key)=\(.value|tostring)\"  ) | .[]" >> ./${img_name_param}_install.sh
cat ${json_deploy_file_param} | jq -r ".${img_name_param}.install_sequence[]" >> ./${img_name_param}_install.sh
echo "COPY ./${img_name_param}_install.sh /${img_name_param}_install.sh" >> ./Dockerfile
echo "RUN chmod +x /${img_name_param}_install.sh; /${img_name_param}_install.sh" >> ./Dockerfile

}


rm -fr ./.install_artifacts
mkdir -p ./.install_artifacts
cd ./.install_artifacts
echo "#!/bin/bash" > ./${img_name}_install.sh
write_dockerfile ${deploy_cfg_file} ${img_name}
cat ./Dockerfile
rm -f ./resolv.conf
cp /etc/resolv.conf ./
docker build --tag ${img_name} ./
cd -
 
set +x


