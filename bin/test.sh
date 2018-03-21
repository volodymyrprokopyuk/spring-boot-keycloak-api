#!/usr/bin/env bash

set -eu

readonly REALM=WebApplication
readonly CLIENT_ID=ApiClient
readonly CLIENT_SECRET=743960ec-97b2-4cb8-85c8-2346ab96a9a3

readonly KEYCLOAK_URL=http://localhost:9090/auth
readonly TOKEN_URL="${KEYCLOAK_URL}/realms/${REALM}/protocol/openid-connect/token"

readonly SERVICE_URL=http://localhost:8081/api
readonly PRODUCTS_URL="${SERVICE_URL}/products"
readonly CUSTOMERS_URL="${SERVICE_URL}/customers"

keycloak_get_resource_owner_password_token() {
    local user="${1:?ERROR: user not provided}"
    local password="${2:?ERROR: password not provided}"

    curl -s "${TOKEN_URL}" \
        -d "grant_type=password" \
        -d "username=${user}" \
        -d "password=${password}" \
        -d "client_id=${CLIENT_ID}" \
        -d "client_secret=${CLIENT_SECRET}" \
        | jq -r .access_token
}

keycloak_get_client_credentials_token() {
    curl -s "${TOKEN_URL}" \
        -d "grant_type=client_credentials" \
        -d "client_id=${CLIENT_ID}" \
        -d "client_secret=${CLIENT_SECRET}" \
        | jq -r .access_token
}

service_get_resource() {
    local resource_url="${1:?ERROR: resource URL is not provided}"

    curl -s "${resource_url}" \
        -H "Authorization: Bearer ${TOKEN}"
}

# ** RESOURCE OWNER PASSWORD GRANT TYPE

#USER=vlad
#PASSWORD=vlad
#echo "USER: ${USER}"
#TOKEN=$(keycloak_get_resource_owner_password_token "${USER}" "${PASSWORD}")
#echo "GET ${PRODUCTS_URL}"
#service_get_resource "${PRODUCTS_URL}"
#echo
#echo "GET ${CUSTOMERS_URL}"
#service_get_resource "${CUSTOMERS_URL}"
#echo
#
#USER=svit
#PASSWORD=svit
#echo "USER: ${USER}"
#TOKEN=$(keycloak_get_resource_owner_password_token "${USER}" "${PASSWORD}")
#echo "GET ${PRODUCTS_URL}"
#service_get_resource "${PRODUCTS_URL}"
#echo
#echo "GET ${CUSTOMERS_URL}"
#service_get_resource "${CUSTOMERS_URL}"
#echo

# ** CLIENT CREDENTIALS GRANT TYPE

TOKEN=$(keycloak_get_client_credentials_token)
echo "GET ${PRODUCTS_URL}"
service_get_resource "${PRODUCTS_URL}"
echo
echo "GET ${CUSTOMERS_URL}"
service_get_resource "${CUSTOMERS_URL}"
echo
