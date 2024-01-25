FROM hashicorp/terraform:1.7.0

WORKDIR /app

COPY . /app

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION=us-east-1
ARG AWS_DEFAULT_OUTPUT=json

RUN apk add --update aws-cli

RUN aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID && \
    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY && \
    aws configure set region $AWS_DEFAULT_REGION && \
    aws configure set output $AWS_DEFAULT_OUTPUT

RUN terraform init

CMD ["terraform", "plan"]