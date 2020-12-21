
#alias aws='sudo docker run --rm -v $ROOT/aws:/root/.aws -it amazon/aws-cli' 

aws() {
    sudo docker run --rm -v $ROOT/aws:/root/.aws -v $ROOT:/fs amazon/aws-cli "$@"
}
export -f aws
