#!/usr/bin/env bash

set -eu

readonly REALM=WebApplication
readonly CLIENT_ID=ApiClient
readonly CLIENT_SECRET=743960ec-97b2-4cb8-85c8-2346ab96a9a3

readonly KEYCLOAK_URL=http://localhost:9090/auth
readonly TOKEN_URL="${KEYCLOAK_URL}/realms/${REALM}/protocol/openid-connect/token"

readonly SERVER_URL=http://localhost:8081/api
readonly PRODUCTS_URL="${SERVER_URL}/products"
readonly CUSTOMERS_URL="${SERVER_URL}/customers"

keycloak_get_token() {
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

server_get_resource() {
    local resource_url="${1:?ERROR: resource URL is not provided}"

    curl -s "${resource_url}" \
        -H "Authorization: Bearer ${TOKEN}"
}

USER=vlad
PASSWORD=vlad
echo "USER: ${USER}"
TOKEN=$(keycloak_get_token "${USER}" "${PASSWORD}")
echo "GET ${PRODUCTS_URL}"
server_get_resource "${PRODUCTS_URL}"
echo
echo "GET ${CUSTOMERS_URL}"
server_get_resource "${CUSTOMERS_URL}"
echo

USER=svit
PASSWORD=svit
echo "USER: ${USER}"
TOKEN=$(keycloak_get_token "${USER}" "${PASSWORD}")
echo "GET ${PRODUCTS_URL}"
server_get_resource "${PRODUCTS_URL}"
echo
echo "GET ${CUSTOMERS_URL}"
server_get_resource "${CUSTOMERS_URL}"
echo
