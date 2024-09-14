.PHONY: all report cppcheck gcc-analyzer clang-tidy

all: serve_debug serve_cov serve

serve_debug: serve.c
	gcc serve.c -o serve_debug -Wall -Wextra -O0 -ggdb

serve_cov: serve.c
	gcc serve.c -o serve_cov -Wall -Wextra -O2 -fprofile-arcs -ftest-coverage -lgcov

serve: serve.c
	gcc serve.c -o serve -Wall -Wextra -O2 -DNDEBUG -DRELEASE

report: 
	lcov --capture --directory . --output-file coverage.info
	@ mkdir -p report
	genhtml coverage.info --output-directory report

cppcheck:
	cppcheck -j1 --enable=portability serve.c
	cppcheck -j1 --enable=style serve.c

gcc-analyzer:
	gcc -c -fanalyzer serve.c

clang-tidy:
	clang-tidy serve.c