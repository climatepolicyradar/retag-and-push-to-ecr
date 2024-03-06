build_bats:
	docker build .github/tests/bats -t bats-with-helpers:latest

test_bashscripts: build_bats
	docker run --rm -v "${PWD}/.github:/code" bats-with-helpers:latest /code/tests/