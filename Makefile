# Makefile for building the Admission Controller webhook.

.DEFAULT_GOAL := docker-build

# Image URL to use all building/pushing image targets cdp-cdp-quota-customizer
IMAGE ?= daocloud.io/daocloud/cdp-quota-customizer:latest
# deploy in which namespace
NAMESPACE ?= cdp-customizer

image/webhook-server: $(shell find . -name '*.go')
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o cdp-quota-customizer

# Build the docker image
docker-build: image/webhook-server
	docker build --no-cache . -t $(IMAGE)
	rm -rf cdp-quota-customizer

# Push the docker image
docker-push:
	docker push $(IMAGE)


deploy:
	kubectl apply -f deployment/rbac.yaml -n cdp-customizer
	kubectl apply -f deployment/service.yaml -n cdp-customizer
	kubectl apply -f deployment/deployment.yaml -n cdp-customizer
	kubectl apply -f deployment/webhook-cert.yaml
	kubectl apply -f deployment/validatewebhook-auto-cert.yaml

undeploy:
	kubectl delete -f deployment/rbac.yaml -n cdp-customizer
	kubectl delete -f deployment/service.yaml -n cdp-customizer
	kubectl delete -f deployment/deployment.yaml -n cdp-customizer
	kubectl delete -f deployment/webhook-cert.yaml
	kubectl delete -f deployment/validatewebhook-auto-cert.yaml