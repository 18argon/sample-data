# global operations for docker images

# NOTE: final '.' excludes the 'docker' dir itself
TARGETS := $(sort $(dir $(wildcard docker/*/.)))

.PHONY: all
all:
	@for DIR in $(TARGETS); do  \
		if [ -f $$DIR/makefile ]; then \
			echo "Cleaning $$DIR";  \
			$(MAKE) -C $$DIR all; \
		fi \
	done

.PHONY: clean
clean:
	@for DIR in $(TARGETS); do  \
		if [ -f $$DIR/makefile ]; then \
			echo "Cleaning $$DIR";  \
			$(MAKE) -C $$DIR clean; \
		fi \
	done
