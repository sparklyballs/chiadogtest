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
stage('Dangerous shit') {
steps {
                echo "username is ${env.GITHUB_CREDS_USR}"
                echo "password is ${env.GITHUB_CREDS_PSW}"
	}
	}

stage('Get RELEASE') {
steps {
script{
	env.RELEASE_VER = sh(script: 'curl -sX GET "${RELEASE_PARAMS}" | jq -r ".tag_name"', returnStdout: true).trim() 
	}
	}
	}
stage('Build image') {
steps {
	sh "docker buildx build \
	--no-cache \
	--pull \
	-t \"${env.DOCKERHUB_REPOSITORY}\":\"${env.BUILD_NUMBER}\" \
	--build-arg RELEASE=\"${env.RELEASE_VER}\" \
	."
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

}
}
