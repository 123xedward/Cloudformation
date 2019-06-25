#!/bin/bash
cd /Users/edwardmontes/Documents/github/Cloudformation/DRP

#Borramos previamente los stacks creados
echo '======Eliminacion previa de stacks incompletos...======'
aws cloudformation delete-stack --stack-name RDS --region eu-west-1
aws cloudformation wait stack-delete-complete --stack-name RDS --region eu-west-1

aws cloudformation delete-stack --stack-name AutoScaling --region eu-west-1
aws cloudformation wait stack-delete-complete --stack-name AutoScaling --region eu-west-1

aws cloudformation delete-stack --stack-name Endpoints --region eu-west-1
aws cloudformation wait stack-delete-complete --stack-name Endpoints --region eu-west-1

aws cloudformation delete-stack --stack-name Notification --region eu-west-1
aws cloudformation wait stack-delete-complete --stack-name Notification --region eu-west-1

aws cloudformation delete-stack --stack-name Security --region eu-west-1
aws cloudformation wait stack-delete-complete --stack-name Security --region eu-west-1

aws cloudformation delete-stack --stack-name VPC --region eu-west-1
aws cloudformation wait stack-delete-complete --stack-name VPC --region eu-west-1

#Directorio de Stacks
cd /Users/edwardmontes/Documents/github/Cloudformation/DRP

#Creacion de Red
echo '======Creacion del Networking...======'
aws cloudformation create-stack --stack-name VPC --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/VPC.yaml \
--parameters \
ParameterKey=AZ1,ParameterValue=eu-west-1a \
ParameterKey=AZ2,ParameterValue=eu-west-1b \
--region eu-west-1

#Pausa para crear la Red
aws cloudformation wait stack-create-complete --stack-name VPC --region eu-west-1

#Creacion Producto Security
echo '======Creacion del stack de seguridad...======'
aws cloudformation create-stack --stack-name Security --capabilities CAPABILITY_IAM --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/Security.yaml \
--region eu-west-1

#Pausa para crear Seguridad
aws cloudformation wait stack-create-complete --stack-name Security --region eu-west-1

#Creacion Producto Notification
echo '======Creacion del topico...======'
aws cloudformation create-stack --stack-name Notification --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/Notification.yaml \
--region eu-west-1

#Pausa para crear Notification
aws cloudformation wait stack-create-complete --stack-name Notification --region eu-west-1

#Creacion Producto Endpoints
echo '======Creacion de los Endpoints...======'
aws cloudformation create-stack --stack-name Endpoints --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/Endpoints.yaml \
--region eu-west-1

#Pausa para crear Endpoints
aws cloudformation wait stack-create-complete --stack-name Endpoints --region eu-west-1

#Creacion Producto AutoScaling
echo '======Creacion del AutoScaling...======'
aws ec2 delete-key-pair --key-name DemoDRP --region eu-west-1
aws ec2 create-key-pair --key-name DemoDRP --region eu-west-1
sleep 1

aws cloudformation create-stack --stack-name AutoScaling --capabilities CAPABILITY_IAM --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/AutoScaling.yaml \
--parameters ParameterKey=ImageId,ParameterValue=ami-01f3682deed220c2a --region eu-west-1

#Pausa para crear AutoScaling
aws cloudformation wait stack-create-complete --stack-name AutoScaling --region eu-west-1

#Creacion Producto RDS
echo '======Creacion de la Base de Datos...======'
aws ssm delete-parameter --name passwordDB --region eu-west-1
aws ssm put-parameter --name passwordDB --value passwordDB --type SecureString --region eu-west-1

aws cloudformation create-stack --stack-name RDS --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/RDS.yaml \
--region eu-west-1