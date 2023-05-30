FROM python:3.9 AS chiadog_build

# build arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG RELEASE

# environment variables
ENV TZ="UTC"

# set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install dependencies
RUN \
	apt-get update \
	&& apt-get install \
	--no-install-recommends -y \
		ca-certificates \
		curl \
		jq \
		lsb-release \
		sudo

# set workdir
WORKDIR /chiadog

# build package
RUN \
	if [ -z ${RELEASE+x} ]; then \
	RELEASE=$(curl -u "${SECRETUSER}:${SECRETPASS}" -sX GET "https://api.github.com/repos/martomi/chiadog/releases/latest" \
	| jq -r ".tag_name"); \
	fi \
	&& git clone -b "${RELEASE}" https://github.com/martomi/chiadog.git . \
	&& /bin/bash install.sh

FROM python:3.9-slim

# set workdir
WORKDIR /chiadog

# install dependencies
RUN \
	apt-get update \
	&& apt-get install \
	--no-install-recommends -y \
		tzdata \
	\
# set timezone
	\
	&& ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime \
	&& echo "$TZ" > /etc/timezone \
	&& dpkg-reconfigure -f noninteractive tzdata \
	\
# cleanup
	\
	&& rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

# copy build files
COPY --from=chiadog_build /chiadog /chiadog

# add local files
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
