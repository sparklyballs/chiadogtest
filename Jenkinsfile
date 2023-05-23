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

stage('Build Docker Image') {
steps {
	sh ('docker buildx build \
	--no-cache \
	--pull \
	-t $CONTAINER_REPOSITORY:$BUILD_NUMBER \
	--build-arg RELEASE=$RELEASE_VER \
	.')
	}
	}

stage('Tag Docker Images') {
steps {
	sh ('docker image tag \
	$CONTAINER_REPOSITORY:$BUILD_NUMBER \
	$CONTAINER_REPOSITORY:$RELEASE_VER')

	sh ('docker image tag \
	$CONTAINER_REPOSITORY:$BUILD_NUMBER \
	$CONTAINER_REPOSITORY:latest')
	}
	}

stage('Push Docker Images') {
steps {
	sh ('echo $CREDS_DOCKERHUB_PSW | docker login -u $CREDS_DOCKERHUB_USR --password-stdin')
	}
	}

}
}
