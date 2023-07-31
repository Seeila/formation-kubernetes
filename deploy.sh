# build docker images with latest tag and unique tag to have kubernetes detect image change
docker build -t shicknventive/multi-client:latest \ 
            -t shicknventive/multi-client:$SHA \ 
            -f ./client/Dockerfile ./client

docker build -t shicknventive/multi-server:latest \
            -t shicknventive/multi-server:$SHA \
            -f ./server/Dockerfile ./server

docker build -t shicknventive/multi-worker:latest \
            -t shicknventive/multi-worker:$SHA \
            -f ./worker/Dockerfile ./worker

# push them to dockerhub
docker push shicknventive/multi-client:latest
docker push shicknventive/multi-client:$SHA

docker push shicknventive/multi-server:latest
docker push shicknventive/multi-server:$SHA

docker push shicknventive/multi-worker:latest
docker push shicknventive/multi-worker:$SHA

# apply kubectl configs
kubectl apply -f k8s

#set the image for each deployments dempending on the sha to be able to detect image update from tag
kubectl set image deployments/server-deployment server=shicknventive/multi-server:$SHA
kubectl set image deployments/client-deployment client=shicknventive/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=shicknventive/multi-worker:$SHA
