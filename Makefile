.SUFFIXES:
MAKEFLAGS+=-r

.PHONY: all clean test build benchmark package
.DEFAULT: all

# GO shit
ROOT_DIR:=$(realpath $(CURDIR))
export GOPATH:=$(ROOT_DIR)

# version & build time
VERSION:=$(shell git describe --dirty --tags)
ifeq (,$(VERSION))
VERSION:="UNKNOWN"
endif
BUILD:=$(shell date -u +%FT%TZ)
HOSTNAME:=$(shell hostname)
ifeq (,$(HOSTNAME))
HOSTNAME:="hostname.unknown"
endif
TARGET:="yal"


all: clean build

clean:
	@echo cleaning...
	@rm -rf $(TARGET)
	@rm -rf *.rpm
	@rm -rf __pycache__/

test:
	@echo unit testing...
	cd src/yal; go test -cover ./...

benchmark:
	@echo benchmark...
	cd src/yal; go test -benchmem -bench=. ./... -run=none

build:
	@echo building...
	cd src/yal; go build -o ../../$(TARGET) -ldflags "-X main.Version=$(VERSION) -X main.Build=$(BUILD) -X main.Hostname=$(HOSTNAME)"

package:
	@echo generating rpm...
	python scripts/create_rpm.py $(TARGET) $(VERSION)
