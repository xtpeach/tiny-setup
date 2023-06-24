#!/bin/bash
repo=registry.xtpeach.docker.images.com
echo "Commit Docker Image ({project.name}:{project.version}) to Nexus Repository (${repo})"
docker tag {project.name}:{project.version} ${repo}/{project.name}:{project.version}
docker push ${repo}/{project.name}:{project.version}
