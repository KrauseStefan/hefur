sudo docker build -t hefur .

# sudo docker run -it -p 6969:6969 -p 6970:6970 -name hefur hefur

sudo docker save hefur > hefur.tar
