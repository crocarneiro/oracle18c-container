docker run -d -i --publish=127.0.0.1:1521:1521 --hostname=my_oracle_container --name=my_oracle_container crocarneiro1998/oracle18c-xe

docker run -d -i --publish=127.0.0.1:1521:1521 --name=my_oracle_container oracle18c-xe


docker build . -t oracle18c-xe
docker run -d -i --publish=127.0.0.1:1521:1521 --name=my_oracle_container oracle18c-xe