if [ $(id -u) != "0" ]
then
echo "Please use sudo"
exit
fi

SCRIPT_HOME="`dirname \"$0\"`"
SCRIPT_HOME="`( cd \"$SCRIPT_HOME\" && pwd )`"
TARGET_CERT_DIR=/home/kelghar/git/cubietruck_configuration/docker_configs/traefik/certs
WORKING_DIR=$SCRIPT_HOME/working

mkdir $WORKING_DIR

cd $WORKING_DIR

echo "Create certificate in $WORKING_DIR"

openssl genrsa -out san_domain_com.key 2048
openssl req -new -out san_domain_com.csr -key san_domain_com.key -config $SCRIPT_HOME/multi.cfg
openssl req -text -noout -in san_domain_com.csr
openssl x509 -req -days 365 -in san_domain_com.csr -signkey san_domain_com.key -out san_domain_com.crt -extensions v3_req -extfile $SCRIPT_HOME/multi.cfg

openssl req -new -x509 -extensions v3_ca -keyout cacert.key -out cacert.pem -days 365 -config $SCRIPT_HOME/multi.cfg

echo "Copy to target directory"
cp san_domain_com.crt $TARGET_CERT_DIR/server.crt
cp san_domain_com.key $TARGET_CERT_DIR/server.key

rm -r $WORKING_DIR
