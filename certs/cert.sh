rm *.pem
rm *.key
rm *.crt
rm *.req
rm *.srl

# 1. Generate EC private key and self-signed certificate
#openssl ecparam -genkey -out ca.key -name secp256k1 
openssl genpkey -algorithm RSA -out ca.key
openssl req -x509 -new -key ca.key -out ca.crt -subj "/C=ES/ST=Catalunya/L=Barcelona/O=Build38/OU=DevOps/CN=MOCK CA RSA"

echo "CA's self-signed certificate"
openssl x509 -in ca.crt -noout -text
#
# 2. Generate web server's private key and certificate signing request (EC)
#openssl ecparam -genkey -out server.key -name secp256k1 
openssl genpkey -algorithm RSA -out server.key
openssl req  -key server.key -new -out server.csr -subj "/C=ES/ST=Catalunya/L=Barcelona/O=Build38/OU=DevOps/CN=MOCK SERVER RSA"

# 3. Use CA's private key to sign web server's CSR and get back the signed certificate
openssl x509 -req -in server.csr -days 360 -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt -extfile server.ext

echo "Server's signed certificate"
openssl x509 -in server.crt -noout -text

# 4. Generate client's private key and certificate signing request (EC)
openssl genpkey -algorithm RSA -out client_rsa.key
openssl ecparam -genkey -out client_k1.key -name secp256k1 

openssl req -key client_rsa.key -new  -out client_rsa.csr -subj "/C=ES/ST=Catalunya/L=Barcelona/O=Build38/OU=DevOps/CN=MOCK CLIENT RSA"
openssl req -key client_k1.key -new  -out client_k1.csr -subj "/C=ES/ST=Catalunya/L=Barcelona/O=Build38/OU=DevOps/CN=MOCK CLIENT K1"

# 5. Use CA's private key to sign client's CSR and get back the signed certificate
openssl x509 -req -in client_rsa.csr -days 360 -CA ca.crt -CAkey ca.key -set_serial 02 -out client_rsa.crt -extfile client.ext
openssl x509 -req -in client_k1.csr -days 360 -CA ca.crt -CAkey ca.key -set_serial 03 -out client_k1.crt -extfile client.ext
#
#echo "Client's signed certificate"
#openssl x509 -in client.cert -noout -text
#
## 6. To verify the server certificate aginst by root CA
#echo "server's certificate verification"
#openssl verify -show_chain -CAfile ca.cert server.cert
#
## 7. To verify the client certificate aginst by root CA.
#echo "client's certificate verification"
#openssl verify -show_chain -CAfile ca.cert client.cert

