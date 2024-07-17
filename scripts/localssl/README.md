Pass for pfx is "localhostssl"


# Generate the certs

openssl req -config localhost.conf -new -x509 -sha256 -newkey rsa:2048 -nodes \
    -keyout localhost.key -days 3650 -out localhost.crt

openssl pkcs12 -export -out localhost.pfx -inkey localhost.key -in localhost.crt


# Trusting the certs

Install the cert utils
sudo apt install libnss3-tools

Trust the certificate for SSL
pk12util -d sql:$HOME/.pki/nssdb -i localhost.pfx

Trust a self-signed server certificate
certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n 'dev cert' -i localhost.crt


Make directory under /usr/share/ca-certificates
mkdir /usr/share/ca-certificates/myca

Put the localhost.crt in it
cp ./localhost.crt /usr/share/ca-certificates/myca/

Run dpkg-reconfigure ca-certificates, choose ask to selectively add new trust anchors and select in the second screen your new myca/myca.crt and press OK
dpkg-reconfigure ca-certificates


