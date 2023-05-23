pipeline {
	agent {
	label 'DOCKER_BUILD_X86_64'
	}

environment {
/*	GITHUB_CREDS=credentials('bd8b00ff-decf-4a75-9e56-1ea2c7d0d708') */
	RELEASE_PARAMS = 'https://api.github.com/repos/martomi/chiadog/releases/latest'
	CONTAINER_NAME = 'chiadogtest'
	DOCKERHUB_REPOSITORY = 'sparklyballs/chiadogtest'
	DOCKERHUB_CREDS=credentials('420d305d-4feb-4f56-802b-a3382c561226')
	}

stages {

stage('Get RELEASE') {
steps {
script{
	env.RELEASE_VER = sh(script: 'curl -sX GET "${RELEASE_PARAMS}" | jq -r ".tag_name"', returnStdout: true).trim() 
	}
	}
	}

stage('Build image') {
steps {
	sh ('docker buildx build \
	--no-cache \
	--pull \
	-t $DOCKERHUB_REPOSITORY:$BUILD_NUMBER \
	--build-arg RELEASE=$RELEASE_VER \
	.')
	}
	}

stage('Tag image') {
steps {
	sh "docker image tag \
	\"${env.DOCKERHUB_REPOSITORY}\":\"${env.BUILD_NUMBER}\" \
	\"${env.DOCKERHUB_REPOSITORY}\":\"${env.RELEASE_VER}\""

	sh "docker image tag \
	\"${env.DOCKERHUB_REPOSITORY}\":\"${env.BUILD_NUMBER}\" \
	\"${env.DOCKERHUB_REPOSITORY}\":latest"
	}
	}

stage('Push images') {
steps {
	sh ('echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin')
	}
	}

}
}
