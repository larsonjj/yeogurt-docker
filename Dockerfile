# Setup Yeogurt development environment
FROM ubuntu:14.04
MAINTAINER Jake Larson <jake.j.larson@gmail.com>

# Update Ubuntu Dependencies
RUN apt-get -yq update && apt-get -yq upgrade

# Install make, git, curl, and libssl-dev
RUN apt-get install make libssl-dev curl git -y

# Configure git to use HTTPS instead of git port (Fixes issues with corporate networks)
RUN git config --global url."https://".insteadOf git://

# Install build Git
RUN apt-get install git -y

# Configure git to use HTTPS instead of git port (Fixes issues with corporate networks)
RUN git config --global url."https://".insteadOf git://

##- Install Node.js -##

# Download 'n' node version manager
RUN curl -#L https://github.com/visionmedia/n/archive/v1.2.7.tar.gz | tar -xzv

# Go into downloaded directory and install 'n'
RUN cd n-1.2.7 && sudo make install

# Install Node
RUN n 0.10.31

# Cleanup
RUN rm -rf n-1.2.7/

##- Install Yeogurt -##

# Update dependencies
RUN apt-get update -y

# Install yeoman, bower, grunt, and generator-yeogurt
RUN npm install -g yo generator-yeogurt

##- Install MongoDB -##

# Update apt-get to get 10gen stable packages
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Update dependencies
RUN apt-get update -y

# Install specific mongodb stable version
RUN apt-get install -y mongodb-org=2.6.1 mongodb-org-server=2.6.1 mongodb-org-shell=2.6.1 mongodb-org-mongos=2.6.1 mongodb-org-tools=2.6.1

# Pin to the exact version above, so it's not auto upgraded by apt-get
RUN echo "mongodb-10gen hold" | dpkg --set-selections

##- Install MySQL -##

# Update dependencies
RUN apt-get update -y

# Install MySQL server with default username and password
RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
RUN apt-get -y install mysql-server

##- Setup yeoman user -##

# Add a yeogurt user because grunt doesn't like being root
RUN adduser --disabled-password --gecos "" yeogurt; \
  echo "yeogurt ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/yeogurt
USER yeogurt
WORKDIR /home/yeogurt

##- Expose ports -##
EXPOSE 9010 # App server
EXPOSE 9011 # Test server
EXPOSE 35729 # Live reload
EXPOSE 5858 # Node debugger

##- Setup Bash -##
CMD ["/bin/bash"]
