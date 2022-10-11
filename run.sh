#!/bin/bash

echo "Java Cro 2022 Hoodie Shop Demo"

case "${1}" in
1)
  echo " >>> step 1: create database image"
  # using docker
  # cd database/docker-build
  # docker build -t hoodie-db:1.0 .
  # cd ../..
  # using maven
  cd database
  mvn install
  cd ..
  ;;
2)
  echo " >>> step 2: start database container"
  docker run --name local-hoodie-db -e MARIADB_ROOT_PASSWORD=mypass -e MARIADB_USER=catalogue_user -e MARIADB_PASSWORD=catalogue_pass -e MARIADB_DATABASE=hoodiedb -d -p 3306:3306 hoodie-db:1.0
  echo "Database available at ..."
  docker inspect local-hoodie-db | grep IPAddress
  ;;
3)
  echo " >>> step 3: destroy database container"
  docker stop local-hoodie-db && docker rm local-hoodie-db
  ;;
4)
  echo " >> step 4: destroy database on local Kubernetes cluster, by deleting namespace"
  kubectl delete namespace hoodie-shop
  ;;
5)
  echo " >> step 5: build & start the backend"
  cd backend
  . /Users/iuliana/.sdkman/bin/sdkman-init.sh # to interpret the .sdkmanrc file
  mvn
  cd ..
  echo "Starting the app ..."
  java -version
  java -jar backend/target/backend.jar
  ;;
6)
  echo " >> step 6: build the NATIVE backend" # to interpret the .sdkmanrc file
  cd backend-native
  . /Users/iuliana/.sdkman/bin/sdkman-init.sh
  mvn package -Pnative -DskipTests
  cd ..
  ;;
7)
  echo " >> step 7: start the NATIVE backend"
  java -version # to make sure we are using GraalVM here
  ./backend-native/target/backend-native   # --DB_HOST=localhost --DB_PORT=31413
  ;;
8)
  echo " >> step 8: build the frontend"
  cd frontend
  # npm install
  export REACT_APP_BACKEND_URL=http://localhost:8082; npm run build
  cd ..
  ;;
9)
  echo " >> step 9: start the frontend"
  cd frontend
  npm start
  cd ..
  ;;
# 2 , 7 & 9 - to run app locally
10)
  echo " >>> step 10: create custom NATIVE image"
  cd backend-native
  mvn spring-boot:build-image -Dspring-boot.build-image.imageName=hoodie-bck-native:1.0
  cd ..
  ;;
11)
  echo " >>> step 11: create frontend image"
  cd frontend
  docker build -t hoodie-frontend:1.0 .
  cd ..
  ;;
12)
  # requires image hoodie-db:1.0 , run step 1
  # requires image hoodie-backend:1.0 , run step 10
  echo " >>> step 12: Deploy backend & database on local Kubernetes cluster"
  kubectl delete namespace java-cro
  kubectl create namespace java-cro
  kubectl config set-context --current --namespace=java-cro

  kubectl apply -f kubernetes/k8s-app.yaml

  export DB_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services hoodie-db)
  export DB_HOST=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" services hoodie-db)
  echo "Database available at ... jdbc:mariadb://${DB_HOST}:${DB_PORT}/hoodiedb"

  export BCK_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services hoodie-backend)
  # update the ui config to point at the right backend
  sed -i -e "s/:[0-9]\{5\}/:${BCK_PORT}/g" kubernetes/k8s-ui.yaml
  export BCK_URL=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" services hoodie-backend)
  echo "Spring Boot app available at ... http://${BCK_URL}:${BCK_PORT}/catalogue/hoodie"
  ;;
13)
  # requires image hoodie-frontend:1.0 , run step 11
  echo " >>> step 13: Deploy UI on local Kubernetes cluster"

  kubectl config set-context --current --namespace=java-cro
  kubectl apply -f kubernetes/k8s-ui.yaml

  export UI_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services hoodie-frontend)
  export UI_URL=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" services hoodie-frontend)
  echo "Ui app available at ... http://${UI_URL}:${UI_PORT}/catalog"
  ;;
14)
  echo " >>> step 14: Tear down the java-cro namespace"
  kubectl delete namespace java-cro
  ;;
15)
  echo " >>> step 15: Using terraform to deploy backend, database & ui on local Kubernetes cluster"
  cd terraform/app
  echo "     >> Deploying backend & database"
  terraform apply --auto-approve
  terraform apply --auto-approve # needed to get correct ingress values

  # getting backend url for react to forward to
  kubectl config set-context --current --namespace=hoodie-shop
  export BCK_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services hoodie-backend)
  export BCK_URL=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" services hoodie-backend)
  export TF_VAR_backend_location="http://${BCK_URL}:${BCK_PORT}"

  cd ../ui
  echo "backend_location = \"${TF_VAR_backend_location}\"" > terraform.tfvars
  echo "     >> Deploying ui"
  terraform apply --auto-approve
  terraform apply --auto-approve # needed to get correct ingress values
  cd ../..
  ;;
16)
  echo " >>> step 15: Destroy terraform deployment"
  cd terraform/ui
  echo "     >> Destroing ui"
  terraform destroy --auto-approve
  cd ../app
  echo "     >> Destroing app & db"
  terraform destroy --auto-approve
  cd ../..
  ;;
esac

