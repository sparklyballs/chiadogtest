pipeline {
	agent {
	label 'DOCKER_BUILD_X86_64'
	}

environment {
/*	GITHUB_CREDS=credentials('bd8b00ff-decf-4a75-9e56-1ea2c7d0d708') */
	CONTAINER_NAME = 'chiadogtest'
	DOCKERHUB_REPOSITORY = 'sparklyballs/chiadogtest'
	DOCKERHUB_CREDS=credentials('420d305d-4feb-4f56-802b-a3382c561226')
	}

stages {
stage('Get RELEASE') {
steps {
script{
	env.RELEASE_VER = sh(script: 'curl -sX GET "https://api.github.com/repos/martomi/chiadog/releases/latest" | jq -r ".tag_name"', returnStdout: true) 
	}
	}
	}
stage('Build image') {
steps {
	sh "docker buildx build \
	-t \"${env.DOCKERHUB_REPOSITORY}\" \
	--no-cache \
	."
	}
	}
}
}
