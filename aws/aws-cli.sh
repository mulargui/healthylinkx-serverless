
#alias aws='sudo docker run --rm -v $ROOT/aws:/root/.aws -it amazon/aws-cli' 

aws() {
    sudo docker run --rm -v $ROOT/aws:/root/.aws -v $ROOT:/fs -it amazon/aws-cli "$@"
}
export -f aws

aws2() {
    sudo docker run --rm -v $ROOT/aws:/root/.aws -v $ROOT/ux/src:/src -it amazon/aws-cli "$@"
}
export -f aws2


