node('DOCKER_BUILD_X86_64') {
    def app
    def RELEASE = sh(script: 'curl -sX GET "https://api.github.com/repos/martomi/chiadog/releases/latest" | jq -r ".tag_name"', returnStdout: true)

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("$DOCKERHUB_REPOSITORY")
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', '420d305d-4feb-4f56-802b-a3382c561226') {
            app.push("${RELEASE}")
            app.push("latest")
        }
    }
}

