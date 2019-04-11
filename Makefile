DESTDIR=server
define terminal
	osascript -e 'tell application "Terminal" to do script "cd $(PWD); $1"'
endef

all: service start
	@echo "Done"

docker-all: docker-build docker-start
	@echo "DONE"

docker-build:
	@echo "building the image from docker file..."
	docker build -t tbalson/cpu .
	@echo "image DONE"

docker-start:
	@echo "starting the service in container..."
	docker run -v /home/:/home/ -p 8080:8080 tbalson/cpu

dest:
	mkdir -p $(DESTDIR)

service: dest
	@echo "creating the service..."
	pip install --upgrade pip
	pip install -r requirements.txt
	start

start:  
	@echo "starting the service..."
	python server.py

docker-stop:
	@echo "stoping the service..."
	docker stop $$(docker ps -alq)
	@echo "service stopped"

docker-remove:
	@echo "removing the image..."
	docker rmi -f tbalson/cpu
	@echo "image removed"

docker-clean: docker-stop docker-remove
	@echo "DONE"




