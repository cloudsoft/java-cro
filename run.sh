#!/bin/bash

echo "Java Cro 2022 Hoodie Shop Demo"

case "${1}" in
1)
  echo " >> step 1: create database image & start container"
  cd database/docker-build
  docker build -t hoodie-db:1.0 .
  cd ../..
  docker run --name local-hoodie-db -e MARIADB_ROOT_PASSWORD=mypass -e MARIADB_USER=catalogue_user -e MARIADB_PASSWORD=catalogue_pass -e MARIADB_DATABASE=hoodiedb -d -p 3306:3306 hoodie-db:1.0
  echo "Database available at ..."
  docker inspect local-hoodie-db | grep IPAddress
  ;;
2)
  echo " >> step 2: destroy database container"
  docker stop local-hoodie-db && docker rm local-hoodie-db
  ;;
3)
  echo " >> step 3: deploy database on local Kubernetes cluster"
  kubectl delete namespace hoodie-shop
  kubectl create namespace hoodie-shop
  kubectl config set-context --current --namespace=hoodie-shop

  kubectl apply -f database/resources/k8s-deploy.yaml

  export NODE_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services hoodie-db)
  export NODE_IP=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[0].address}")
  echo "Database available at ... mariadb://${NODE_IP}:${NODE_PORT}"
  ;;
4)
  echo " >> step 4: destroy database on local Kubernetes cluster"
  kubectl delete namespace hoodie-shop
  ;;
5)
  echo " >> step 5: building the backend"
  cd backend
  mvn
  cd ..
  echo "Starting the app "
  java -jar backend/target/backend.jar
  ;;
esac

