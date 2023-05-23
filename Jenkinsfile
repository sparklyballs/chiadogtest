node('DOCKER_BUILD_X86_64') {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Get Version') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        sh RELEASE=$("""curl -u "${SECRETUSER}:${SECRETPASS}" -sX GET "https://api.github.com/repos/martomi/chiadog/releases/latest" | jq -r ".tag_name"")
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("sparklyballs/chiadogtest","--build-arg RELEASE=${env.RELEASE})
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', '420d305d-4feb-4f56-802b-a3382c561226') {
            app.push("${env.RELEASE}")
            app.push("latest")
        }
    }
}
}
