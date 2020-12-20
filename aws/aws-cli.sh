
aws() {
    sudo docker run --rm -v $ROOT/aws:/root/.aws -it amazon/aws-cli "$@"
}
export -f aws

aws2() {
    sudo docker run --rm -v $ROOT/aws:/root/.aws -v $ROOT/ux/src:/src -it amazon/aws-cli "$@"
}
export -f aws2

#alias aws='sudo docker run --rm -v /vagrant/healthylinkx-serverless/aws:/root/.aws -it amazon/aws-cli' 