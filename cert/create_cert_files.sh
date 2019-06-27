if [ $(id -u) != "0" ]
then
echo "Please use sudo"
exit
fi

SCRIPT_HOME="`dirname \"$0\"`"
SCRIPT_HOME="`( cd \"$SCRIPT_HOME\" && pwd )`"
NGINX_CERT_DIR=/home/kelghar/git/cubietruck_configuration/docker_configs/traefik/certs
POSTFIX_CERT_DIR=/etc/postfix/certs
WORKING_DIR=$SCRIPT_HOME/working
#FOLDER_TO_RESTORE=$SCRIPT_HOME/folder_to_restore.list

#xargs mkdir -p < $FOLDER_TO_RESTORE

mkdir $WORKING_DIR

cd $WORKING_DIR

echo "Create certificate in $WORKING_DIR"

openssl genrsa -out san_domain_com.key 2048
openssl req -new -out san_domain_com.csr -key san_domain_com.key -config $SCRIPT_HOME/multi.cfg
openssl req -text -noout -in san_domain_com.csr
openssl x509 -req -days 365 -in san_domain_com.csr -signkey san_domain_com.key -out san_domain_com.crt -extensions v3_req -extfile $SCRIPT_HOME/multi.cfg

openssl req -new -x509 -extensions v3_ca -keyout cacert.key -out cacert.pem -days 3650 -config $SCRIPT_HOME/multi.cfg

echo "Copy to Nginx"
cp san_domain_com.crt $NGINX_CERT_DIR/server.crt
cp san_domain_com.key $NGINX_CERT_DIR/server.key

echo "Copy to Postfix"
#cp san_domain_com.crt $POSTFIX_CERT_DIR/mail.andromeda.home.crt
#cp san_domain_com.key $POSTFIX_CERT_DIR/mail.andromeda.home.key
#cp cacert.pem $POSTFIX_CERT_DIR/mail.andromeda.home.ca

rm -r $WORKING_DIR
