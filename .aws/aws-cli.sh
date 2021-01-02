

#use this alias if you want to use the aws cli docker container instead of installing the software
#aws() {
#    sudo docker run --rm -v $ROOT/.aws:/root/.aws -v $ROOT:/fs amazon/aws-cli "$@"
#}
#export -f aws

#otherwise configure the aws cli (just need to copy the .aws folder to $HOME)
if [ ! -d "$HOME/.aws" ]; then
	cp -r .aws $HOME
fi
