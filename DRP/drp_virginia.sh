#!/bin/bash
cd /Users/edwardmontes/Documents/github/Cloudformation/DRP

#Eliminamos el bucket
echo '======Eliminacion del bucket y recursos...======'
aws s3 rm s3://demodrp123xedward --recursive

#Creamos el bucket
echo '======Creacion del bucket...======'
aws s3 mb s3://demodrp123xedward

#Subimos los archivos al bucket
echo '======Subida de archivos al bucket...======'
aws s3 cp /Users/edwardmontes/Documents/github/Cloudformation/DRP s3://demodrp123xedward/ --recursive

#Borramos previamente los stacks creados
echo '======Eliminacion previa de stacks incompletos...======'
aws cloudformation delete-stack --stack-name RDS
aws cloudformation wait stack-delete-complete --stack-name RDS

aws cloudformation delete-stack --stack-name AutoScaling
aws cloudformation wait stack-delete-complete --stack-name AutoScaling

aws cloudformation delete-stack --stack-name Endpoints
aws cloudformation wait stack-delete-complete --stack-name Endpoints

aws cloudformation delete-stack --stack-name Notification
aws cloudformation wait stack-delete-complete --stack-name Notification

aws cloudformation delete-stack --stack-name Security
aws cloudformation wait stack-delete-complete --stack-name Security

aws cloudformation delete-stack --stack-name VPC
aws cloudformation wait stack-delete-complete --stack-name VPC

#Directorio de Stacks
cd /Users/edwardmontes/Documents/github/Cloudformation/DRP

#Creacion de Red
echo '======Creacion del Networking...======'
aws cloudformation create-stack --stack-name VPC --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/VPC.yaml \

#Pausa para crear la Red
aws cloudformation wait stack-create-complete --stack-name VPC

#Creacion Producto Security
echo '======Creacion del stack de seguridad...======'
aws cloudformation create-stack --stack-name Security --capabilities CAPABILITY_IAM --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/Security.yaml

#Pausa para crear Seguridad
aws cloudformation wait stack-create-complete --stack-name Security

#Creacion Producto Notification
echo '======Creacion del topico...======'
aws cloudformation create-stack --stack-name Notification --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/Notification.yaml 

#Pausa para crear Notification
aws cloudformation wait stack-create-complete --stack-name Notification

#Creacion Producto Endpoints
echo '======Creacion de los Endpoints...======'
aws cloudformation create-stack --stack-name Endpoints --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/Endpoints.yaml

#Pausa para crear Endpoints
aws cloudformation wait stack-create-complete --stack-name Endpoints

#Creacion Producto AutoScaling
echo '======Creacion del AutoScaling...======'
aws ec2 delete-key-pair --key-name DemoDRP
aws ec2 create-key-pair --key-name DemoDRP
sleep 1

aws cloudformation create-stack --stack-name AutoScaling --capabilities CAPABILITY_IAM --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/AutoScaling.yaml \
--parameters ParameterKey=ImageId,ParameterValue=ami-0cc96feef8c6bbff3

#Pausa para crear AutoScaling
aws cloudformation wait stack-create-complete --stack-name AutoScaling

#Creacion Producto RDS
echo '======Creacion de la Base de Datos...======'
aws ssm delete-parameter --name passwordDB --region eu-west-1
aws ssm put-parameter --name passwordDB --value passwordDB --type SecureString --region eu-west-1

aws cloudformation create-stack --stack-name RDS --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/DRP/RDS.yaml \
--region eu-west-1
