Docker Setup for Yeogurt Generator
==============

Setup up Yeogurt generator quick and easy using [Docker](https://docker.io)

## Included Software:

- MongoDB 2.6.1
- MySQL Server 5.5.5
- Node.js 0.10.31
- Latest Yeoman, Grunt, Bower npm packages
- Latest Yeogurt Generator

## Installation

1. Install [Docker](https://docs.docker.com/)
2. Open a terminal/command prompt and run: `docker run -i -t larsonjj/yeogurt`

## Usage
Whenever you want to use this docker image, run:

```docker run -i -t larsonjj/yeogurt```

This will run the container and log you in as the "yeogurt" user and allow you to run the yeogurt generator:

```yo yeogurt```
