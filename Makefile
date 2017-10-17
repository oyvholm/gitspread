#!/usr/bin/make

# Makefile for gitspread
# File ID: 567ed908-6129-11e0-8701-ef2dbadb811d

.PHONY: all
all:

.PHONY: clean
clean:
	cd t && $(MAKE) clean

.PHONY: test
test:
	cd t && $(MAKE) test
