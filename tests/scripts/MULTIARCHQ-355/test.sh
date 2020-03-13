#!/bin/bash

yum install -y git 
git clone http://$1:$2@gitlab.consulting.redhat.com/jlabarre/osp16-openstack-deploy-playbooks.git 
