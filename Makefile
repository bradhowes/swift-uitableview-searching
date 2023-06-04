# XCode scheme to build and test
SCHEME = Searching

# The sim to use when running tests
PLATFORM_IOS = iOS Simulator,name=iPhone SE (3rd generation)

# Coomand line options for xcodebuild that incorporate the above values
DEST = -project Searching.xcodeproj -scheme "$(SCHEME)" -destination platform="$(PLATFORM_IOS)"

# The pattern to use when matching lines from xcov output. The coverage total will be the average
# of all lines that match the pattern.
COV_PATTERN = Searching.app

default: coverage

# Put the coverage percentage into the Github environment for reporting
coverage: percentage.txt
	[[ -n "$$GITHUB_ENV" ]] && echo "PERCENTAGE=$$(< percentage.txt)" >> $$GITHUB_ENV

# Calculate the percentage from the cov.txt contents
percentage.txt: cov.txt
	awk '/$(COV_PATTERN)/ {s+=$$4;++c} END {print s/c;}' < cov.txt > percentage.txt
	@cat percentage.txt

# Generate the cov.txt file fromo the results of the tests.
cov.txt: test
	xcrun xccov view --report --only-targets WD.xcresult > cov.txt
	@cat cov.txt

# Run the tests and capture code coverage
test: build
	xcodebuild test $(DEST) -enableCodeCoverage YES ENABLE_TESTING_SEARCH_PATHS=YES -resultBundlePath $PWD

# Build the UAT
build: clean
	xcodebuild build $(DEST)

clean:
	@echo "-- removing cov.txt percentage.txt"
	@-rm -rf cov.txt percentage.txt WD WD.xcresult
	xcodebuild clean $(DEST)

.PHONY: build test coverage clean
