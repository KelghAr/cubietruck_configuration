uwsgi --socket 127.0.0.1:8080 --protocol=http -w wsgi_klaus_simple --env KLAUS_SITE_NAME="Klaus Home" --env KLAUS_REPOS="/home/kelghar/git/cubietruck_config"
