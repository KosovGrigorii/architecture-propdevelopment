#!/bin/bash

users=("developer" "manager" "devops")
for user in "${users[@]}"; do
  openssl genrsa -out ${user}.key 2048
  openssl req -new -key ${user}.key -out ${user}.csr -subj "/CN=${user}/O=${user}-group"

  openssl x509 -req -in ${user}.csr -CA kubernetes-ca.crt -CAkey kubernetes-ca.key -CAcreateserial -out ${user}.crt -days 365

  kubectl config set-credentials ${user} --client-certificate=${user}.crt --client-key=${user}.key
  kubectl config set-context ${user}-context --cluster=kubernetes --user=${user}
done
