pipeline {
	agent {
	label 'DOCKER_BUILD_X86_64'
	}

environment {
	CREDS_DOCKERHUB=credentials('420d305d-4feb-4f56-802b-a3382c561226')
	CREDS_GITHUB=credentials('bd8b00ff-decf-4a75-9e56-1ea2c7d0d708')
	CONTAINER_NAME = 'chiadogtest'
	CONTAINER_REPOSITORY = 'sparklyballs/chiadogtest'
	RELEASE_PARAMS = 'https://api.github.com/repos/martomi/chiadog/releases/latest'
	}

stages {

stage('Get Release Version') {
steps {
script{
	env.RELEASE_VER = sh(script: 'curl -sX GET "${RELEASE_PARAMS}" | jq -r ".tag_name"', returnStdout: true).trim() 
	}
	}
	}

stage ("Lint Dockerfile") {
steps {
	sh ('docker pull sparklyballs/hadolint')
	sh ('docker run \
	--rm=true -it \
	-v $WORKSPACE/Dockerfile:/Dockerfile \
	sparklyballs/hadolint \
	hadolint /Dockerfile > $WORKSPACE/hadolint-result.xml')
	}
	}

stage('Build Docker Image') {
steps {
	sh ('docker buildx build \
	--no-cache \
	--pull \
	-t $CONTAINER_REPOSITORY:latest \
	-t $CONTAINER_REPOSITORY:$RELEASE_VER \
	--build-arg RELEASE=$RELEASE_VER \
	.')
	}
	}

stage('Push Docker Images') {
steps {
	sh ('echo $CREDS_DOCKERHUB_PSW | docker login -u $CREDS_DOCKERHUB_USR --password-stdin')
	sh ('docker image push $CONTAINER_REPOSITORY:latest')
	sh ('docker image push $CONTAINER_REPOSITORY:$RELEASE_VER')
	}
	}

}
}
