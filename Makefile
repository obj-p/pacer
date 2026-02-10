.PHONY: all clean generate build distribute

all: clean generate

clean:
	@rm -rf Pacer.xcodeproj
	@rm -rf dist

generate:
	@xcodegen

build:
	@bundle exec fastlane build

distribute:
	@bundle exec fastlane distribute
