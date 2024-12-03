.PHONY: build-polyc clean run-sml example

NAME = sml-app

build-polyc:
	polyc -o $(NAME) ./build.sml

run-sml:
	if command -v rlwrap >/dev/null; then \
		rlwrap sml ./build.sml; \
	else \
		sml ./build.sml; \
	fi


example:
	mkdir -p example/src/01-bar/01-baz/
	mkdir -p example/src/02-foo/
	echo 'val bar = "bar";' > example/src/01-bar/bar.sml
	echo 'val baz = "baz";' > example/src/01-bar/01-baz/baz.sml
	echo 'val foo = "foo";' > example/src/02-foo/foo.sml
	echo 'fun main () = print (foo ^ bar ^ baz);' > example/src/main.sml
	echo 'otherdata' > example/src/data.txt
	cp build.sml example/build.sml
	cp Makefile example/Makefile
	tree example

clean:
	rm -rf example
	rm -f $(NAME)
