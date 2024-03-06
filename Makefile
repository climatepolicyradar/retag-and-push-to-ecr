build_bats:
	docker build tests/bats -t bats-with-helpers:latest

test_bashscripts: build_bats
	docker run --rm -v "${PWD}:/code" bats-with-helpers:latest /code/tests/
