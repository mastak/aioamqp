.PHONY: doc test update

NOSETESTS ?= nosetests

BUILD_DIR ?= build
INPUT_DIR ?= docs

# Sphinx options (are passed to build_docs, which passes them to sphinx-build)
#   -W       : turn warning into errors
#   -a       : write all files
#   -b html  : use html builder
#   -i [pat] : ignore pattern

SPHINXOPTS ?= -a -W -b html
AUTOSPHINXOPTS := -i *~ -i *.sw* -i Makefile*

SPHINXBUILDDIR ?= $(BUILD_DIR)/sphinx/html
ALLSPHINXOPTS ?= -d $(BUILD_DIR)/sphinx/doctrees $(SPHINXOPTS) docs

doc:
	sphinx-build -a $(INPUT_DIR) build

livehtml: docs
	sphinx-autobuild $(AUTOSPHINXOPTS) $(ALLSPHINXOPTS) $(SPHINXBUILDDIR)

test:
	$(NOSETESTS) --verbosity=2 aioamqp

docker_test:
	docker-compose up -d rabbitmq
	docker-compose build aioamqp
	docker-compose run --rm --entrypoint=bash aioamqp -c "while ! curl -s rabbitmq:15672 > /dev/null; do echo waiting for rabbitmq; sleep 1; done"
	docker-compose up aioamqp
	docker-compose stop
	docker-compose rm -f

update:
	pip install -r requirements_dev.txt
