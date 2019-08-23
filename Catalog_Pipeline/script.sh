#!/bin/bash
cd /Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline

#Eliminamos el bucket
aws s3 rm s3://portfolioarchitect123xedward --recursive

#Creamos el bucket
aws s3 mb s3://portfolioarchitect123xedward

#Subimos los archivos al bucket
aws s3 cp /Users/edwardmontes/Documents/github/Cloudformation/DRP s3://portfolioarchitect123xedward/ --recursive

#Borramos previamente los stacks creados
aws cloudformation delete-stack --stack-name RDSProduct 
sleep 1

aws cloudformation delete-stack --stack-name AutoScalingProduct
sleep 1

aws cloudformation delete-stack --stack-name EndpointsProduct
sleep 1

aws cloudformation delete-stack --stack-name NotificationProduct
sleep 1

aws cloudformation delete-stack --stack-name SecurityProduct
sleep 1

aws cloudformation delete-stack --stack-name VPCProduct
sleep 5

aws cloudformation delete-stack --stack-name portafolio
sleep 15

#Directorio de Stacks
cd /Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline 

#Creacion Portafolio
aws cloudformation create-stack --stack-name portafolio --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline/1_Portfolio.yaml \
--parameters ParameterKey=SubAccountID,ParameterValue=979231503863

#Pausa para crear el portafolio
aws cloudformation wait stack-create-complete --stack-name portafolio

#Creacion Producto VPC
aws cloudformation create-stack --stack-name VPCProduct --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline/2_VPCProduct.yaml 
sleep 1

#Creacion Producto Security
aws cloudformation create-stack --stack-name SecurityProduct --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline/3_Security.yaml 
sleep 1

#Creacion Producto Notification
aws cloudformation create-stack --stack-name NotificationProduct --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline/4_Notification.yaml 
sleep 1

#Creacion Producto Endpoints
aws cloudformation create-stack --stack-name EndpointsProduct --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline/5_Endpoints.yaml 
sleep 1

#Creacion Producto AutoScaling
aws cloudformation create-stack --stack-name AutoScalingProduct --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline/6_AutoScaling.yaml 
sleep 1

#Creacion Producto RDS
aws cloudformation create-stack --stack-name RDSProduct --template-body \
file:////Users/edwardmontes/Documents/github/Cloudformation/Catalog_Pipeline/7_RDS.yaml 

#Impresion de salidas
sleep 25
echo "Portafolio ID: "
aws cloudformation describe-stacks --stack-name portafolio | grep port-

echo "VPC: "
aws cloudformation describe-stacks --stack-name VPCProduct | grep prod-
aws cloudformation describe-stacks --stack-name VPCProduct | grep pa-

echo "Security: "
aws cloudformation describe-stacks --stack-name SecurityProduct | grep prod-
aws cloudformation describe-stacks --stack-name SecurityProduct | grep pa-

echo "Notification: "
aws cloudformation describe-stacks --stack-name NotificationProduct | grep prod-
aws cloudformation describe-stacks --stack-name NotificationProduct | grep pa-

echo "Endpoints: "
aws cloudformation describe-stacks --stack-name EndpointsProduct | grep prod-
aws cloudformation describe-stacks --stack-name EndpointsProduct | grep pa-

echo "AutoScaling: "
aws cloudformation describe-stacks --stack-name AutoScalingProduct | grep prod-
aws cloudformation describe-stacks --stack-name AutoScalingProduct | grep pa-

echo "RDS: "
aws cloudformation describe-stacks --stack-name RDSProduct | grep prod-
aws cloudformation describe-stacks --stack-name RDSProduct | grep pa-