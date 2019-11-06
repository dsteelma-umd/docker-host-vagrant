# EPEL
sudo yum install -y epel-release
sudo yum install -y vim git

# install docker
sudo yum remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-selinux \
docker-engine-selinux \
docker-engine
sudo yum install -y yum-utils \
device-mapper-persistent-data \
lvm2
sudo yum-config-manager \
--add-repo \
https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce

# vagrant user add docker group
sudo gpasswd -a vagrant docker

# docker running
sudo systemctl enable docker
sudo systemctl start docker

# Start docker swarm
docker swarm init --advertise-addr 192.168.7.25

# Create self-signed certificates and add as Docker secrets
# docker-host.local
openssl req -x509 -new -newkey rsa:2048 -nodes \
          -keyout /tmp/docker.key \
          -out /tmp/docker.cert -days 600 \
          -subj '/C=US/ST=MD/L=College Park/O=University of Maryland/OU=Libraries/CN=docker-host.local'

docker secret create docker-host-cert.v1 /tmp/docker.cert
docker secret create docker-host-key.v1 /tmp/docker.key

# -- orcid
sudo chown -R 9999:docker /apps/docker/logs/orcid/app
docker network create -d overlay --attachable orcid_default

openssl req -x509 -new -newkey rsa:2048 -nodes \
          -keyout /tmp/orcid.key \
          -out /tmp/orcid.cert -days 600 \
          -subj '/C=US/ST=MD/L=College Park/O=University of Maryland/OU=Libraries/CN=orcid.local'

docker secret create orcid-cert.v1 /tmp/orcid.cert
docker secret create orcid-key.v1 /tmp/orcid.key

# -- search
mkdir -p /apps/docker/volumes/search/db
sudo chown -R 9999:docker /apps/docker/logs/search/app
sudo chown -R 8983:docker /apps/docker/logs/search/solr
sudo chown -R vagrant:docker /apps/docker/volumes/search/db
docker network create -d overlay --attachable search_default

openssl req -x509 -new -newkey rsa:2048 -nodes \
          -keyout /tmp/search.key \
          -out /tmp/search.cert -days 600 \
          -subj '/C=US/ST=MD/L=College Park/O=University of Maryland/OU=Libraries/CN=search.local'

docker secret create search-cert.v1 /tmp/search.cert
docker secret create search-key.v1 /tmp/search.key

# -- fcrepo_jenkins_default
docker network create -d overlay --attachable fcrepo_jenkins_default

openssl req -x509 -new -newkey rsa:2048 -nodes \
          -keyout /tmp/fcrepo-jenkins.key \
          -out /tmp/fcrepo-jenkins.cert -days 600 \
          -subj '/C=US/ST=MD/L=College Park/O=University of Maryland/OU=Libraries/CN=ci-fcrepo-jenkins.local'

docker secret create fcrepo-jenkins-cert.v1 /tmp/fcrepo-jenkins.cert
docker secret create fcrepo-jenkins-key.v1 /tmp/fcrepo-jenkins.key

# -- staff_blog
docker network create -d overlay --attachable staff_blog_default
mkdir -p /apps/docker/volumes/staff-blog/db
sudo chown -R 999:vagrant /apps/docker/volumes/staff-blog/db

# -- solr-textbook setup
sudo chown -R 8983:8983 /apps/docker/logs/solr-textbook/app
docker network create -d overlay --attachable solr-textbook_default

# -- solr-plant-patents
sudo chown -R 8983:8983 /apps/docker/logs/solr-plant-patents/app
docker network create -d overlay --attachable solr-plant-patents_default

# -- solr-md-newspapers
sudo chown -R 8983:8983 /apps/docker/logs/solr-md-newspapers/app
docker network create -d overlay --attachable solr-md-newspapers_default

# -- solr-irroc
sudo chown -R 8983:8983 /apps/docker/logs/solr-irroc/app
docker network create -d overlay --attachable solr-irroc_default

# -- solr-scpa-scores
sudo chown -R 8983:8983 /apps/docker/logs/solr-scpa-scores/app
docker network create -d overlay --attachable solr-scpa-scores_default