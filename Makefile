SHELL := $(shell which bash)
PROJECT := greetings

init:
	git config core.ignorecase false
	git config core.hooksPath .githooks

clean:
	find . -name '*.py[co]' -delete
	find . -name '*.skp' -delete
	find . -name '.coverage*' -delete
	rm -rf build dist $(PROJECT).egg-info
	find . -path '*/__pycache__*' -delete
	find . -path '*/.pytest_cache*' -delete
	find . -path '*/cov.xml' -delete
	rm -rf report

validate: clean
	flake8 api

build: clean
	docker build  . -t $(PROJECT):latest

run:
	docker run --rm -d -p 3000:3000 --name $(PROJECT) $(PROJECT):latest
%:
	@:
