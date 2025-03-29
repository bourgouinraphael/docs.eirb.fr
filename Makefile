
.PHONY: all
all:

.PHONY: dev
dev:
	docker compose up -d

.PHONY: build
build:
	docker compose up -d
	docker exec mkdocs mkdocs build

.PHONY: start
start:
	python -m http.server 8080 -d mkdocs/site


.PHONY:clean
clean:
	${RM} -r mkdocs/site
	docker compose down
