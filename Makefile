SCHEME = Searching
PLATFORM_IOS = iOS Simulator,name=iPhone SE (2nd generation)

DEST = -scheme "$(SCHEME)" -destination platform="$(PLATFORM_IOS)" -project Searching.xcodeproj

default: coverage

build: clean
	xcodebuild build $(DEST)

test: build
	xcodebuild test $(DEST) -enableCodeCoverage YES ENABLE_TESTING_SEARCH_PATHS=YES -resultBundlePath $PWD

# Extract coverage info for SoundFonts -- expects definition of env variable GITHUB_ENV

cov.txt: test
	xcrun xccov view --report --only-targets WD.xcresult > cov.txt
	@cat cov.txt

PATTERN = Searching.app

percentage.txt: cov.txt
	awk '/$(PATTERN)/ {s+=$$4;++c} END {print s/c;}' < cov.txt > percentage.txt
	@cat percentage.txt

coverage: percentage.txt
	@if [[ -n "$$GITHUB_ENV" ]]; then \
		echo "PERCENTAGE=$$(< percentage.txt)" >> $$GITHUB_ENV; \
	fi

clean:
	@echo "-- removing cov.txt percentage.txt"
	@-rm -rf cov.txt percentage.txt WD WD.xcresult
	xcodebuild clean $(DEST)

.PHONY: build test coverage clean
