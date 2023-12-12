
FROM busybox:latest
CMD echo 'Built with kaniko from https://gitlab.com/guided-explorations/gitlab-ci-yml-tips-tricks-and-hacks/kaniko-docker-build/'
#When Kaniko Caching is being used each layer is immediately pushed before processing the next RUN command