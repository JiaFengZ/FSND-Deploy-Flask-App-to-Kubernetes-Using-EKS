# Deploying a Flask API

This is the project starter repo for the fourth course in the [Udacity Full Stack Nanodegree](https://www.udacity.com/course/full-stack-web-developer-nanodegree--nd004): Server Deployment, Containerization, and Testing.

In this project you will containerize and deploy a Flask API to a Kubernetes cluster using Docker, AWS EKS, CodePipeline, and CodeBuild.

The Flask app that will be used for this project consists of a simple API with three endpoints:

- `GET '/'`: This is a simple health check, which returns the response 'Healthy'. 
- `POST '/auth'`: This takes a email and password as json arguments and returns a JWT based on a custom secret.
- `GET '/contents'`: This requires a valid JWT, and returns the un-encrpyted contents of that token. 

The app relies on a secret set as the environment variable `JWT_SECRET` to produce a JWT. The built-in Flask server is adequate for local development, but not production, so you will be using the production-ready [Gunicorn](https://gunicorn.org/) server when deploying the app.

## Initial setup
1. Fork this project to your Github account.
2. Locally clone your forked version to begin working on the project.

.\env\Scripts\activate.bat
.\env\Scripts\deactivate.bat

* 指定版本安装 docker-ce ```18.03.1~ce~3-0~ubuntu```
* 设置国内加速镜像源 ```DOCKER_OPTS="--registry-mirror=http://hub-mirror.c.163.com"```
* 安装完毕后启动
```
sudo cgroupfs-mount
// 启动
sudo service docker start
// 重启
sudo service docker restart
// 检查启动状态
sudo service docker status
// 查看docker版本
sudo docker version
```
* 使用dockerfiles 构建镜像
```
docker build -t image_name .
```
* 删除镜像 ```docker rmi image_name```
* 删除容器 ``` sudo docker rm -f container_id```
* 查看容器状态 ```sudo docker ps -a```
* 查看镜像 ```docker images```

* 运行构建
```
sudo docker build . -t=jwt-api-test
sudo docker run --env-file=env_file -d -p 80:8080 jwt-api-test
```

## Dependencies

- Docker Engine
    - Installation instructions for all OSes can be found [here](https://docs.docker.com/install/).
    - For Mac users, if you have no previous Docker Toolbox installation, you can install Docker Desktop for Mac. If you already have a Docker Toolbox installation, please read [this](https://docs.docker.com/docker-for-mac/docker-toolbox/) before installing.
 - AWS Account
     - You can create an AWS account by signing up [here](https://aws.amazon.com/#).
     
## Project Steps

Completing the project involves several steps:

1. Write a Dockerfile for a simple Flask API
2. Build and test the container locally
3. Create an EKS cluster
4. Store a secret using AWS Parameter Store
5. Create a CodePipeline pipeline triggered by GitHub checkins
6. Create a CodeBuild stage which will build, test, and deploy your code

For more detail about each of these steps, see the project lesson [here](https://classroom.udacity.com/nanodegrees/nd004/parts/1d842ebf-5b10-4749-9e5e-ef28fe98f173/modules/ac13842f-c841-4c1a-b284-b47899f4613d/lessons/becb2dac-c108-4143-8f6c-11b30413e28d/concepts/092cdb35-28f7-4145-b6e6-6278b8dd7527).

## guide

### awscli
* To install in a python virtual environment run ```pip install awscli --upgrade``` , for other environments see installation instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).

* Generate keys at the IAM console [here](https://console.aws.amazon.com/iam/home#/users)

* Run ```aws configure``` with the keys from above to setup your profile

* Check that your profile is set: ```aws configure list```

* To test you installation, try listing your S3 buckets: ```aws s3 ls```. This will show all of the S3 buckets in your account.

### [eksctl](https://chocolatey.org/)
* chocolatey install eksctl

### [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/windows/amd64/kubectl.exe
# Add the binary in to your PATH.
kubectl version --client
```

### Creating an EKS Cluster
* ```eksctl create cluster --name simple-jwt-api```
* Go to the [CloudFormation console](https://us-east-2.console.aws.amazon.com/cloudformation/) to view progress. 
* Once the status is ‘CREATE_COMPLETE’, check the health of your clusters nodes: ```kubectl get nodes```
* delete the cluster: ```eksctl delete cluster eksctl-demo```

### Set Up an IAM Role for the Cluster

# Create the role and attach the trust policy that allows EC2 to assume this role.
$ aws iam create-role --role-name Test-Role-for-EC2 --assume-role-policy-document file://C:\policies\trustpolicyforec2.json

$ aws iam create-role --role-name UdacityFlaskDeployCBKubectlRole --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'