_default: compile

clean:
	rm -fr fastcache/_cython/*.c fastcache/*.so build
	find . -name '__pycache__' | xargs rm -rf
	find . -type f -name "*.pyc" -delete

setup-build:
	python setup.py build_ext --inplace

install:
	pip install -e .

install-dev:
	pip install -e ".[dev]"

compile: clean setup-build

format:
	isort --recursive .
	black .

lint:
	isort --check-only --recursive .
	black --check .
	flake8

acceptance:
	pytest -sv tests/acceptance

unit:
	pytest -sv tests/unit

test: unit acceptance

coverage:
	coverage run -m pytest -v tests/ --junitxml=build/test.xml
	coverage xml -i -o build/coverage.xml
	coverage report

stress:
	python benchmark/sets_gets_stress.py --duration 10 --concurrency 32

.PHONY: clean setup-build install install-dev compile unit test acceptance stress
