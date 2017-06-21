#!/bin/bash
set -x

wget ftp://mirror.switch.ch/pool/4/mirror/centos/7.3.1611/cloud/x86_64/openstack-ocata/common/jq-1.3-2.el7.x86_64.rpm
yum -y --nogpgcheck localinstall jq-1.3-2.el7.x86_64.rpm
