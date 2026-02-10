# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Pacer is an Apple Watch app for tracking laps/pace on non-standard indoor tracks. It's structured as a minimal iOS companion app with an embedded watchOS extension to enable ad-hoc OTA distribution.

## Build Commands

The project uses XcodeGen + Fastlane. Ruby 3.4.4 is managed via mise.

```bash
# Generate Xcode project from project.yml
xcodegen

# Build ad-hoc IPA (syncs certs, runs xcodegen, builds)
mise exec -- bundle exec fastlane build

# Build + publish to appserve distribution server
mise exec -- bundle exec fastlane distribute

# Run tests
xcodebuild test -scheme PacerTests -destination 'platform=watchOS Simulator,name=Apple Watch Series 11 (46mm)'
```

## Deploy

The `distribute` lane builds the IPA and publishes it to the shared [appserve](../appserve/) distribution server. The server must be running separately (`make serve` in appserve).

```bash
# Build and publish
mise exec -- bundle exec fastlane distribute

# Install at https://<APPSERVE_DOMAIN>/apps/pacer/latest/
```

To add a new device: register its UDID in the Apple Developer portal (including Apple Watch UDIDs separately), then `mise exec -- bundle exec fastlane match adhoc --force` and rebuild.

## Architecture

```
Pacer/          → iOS companion app (minimal, enables OTA install)
PacerWatch/     → watchOS app (all functionality lives here)
PacerTests/     → Unit tests (imports PacerWatch, uses Swift Testing framework)
```

**Bundle IDs:** `com.objp.Pacer` (iOS), `com.objp.Pacer.watchkitapp` (watchOS)

**Data flow:** `TrackConfiguration` (model, Codable) → `TrackSettings` (@Observable, persists to UserDefaults) → SwiftUI views

`TrackConfiguration` stores track distance in meters as the canonical value, with computed properties for laps-per-unit and distance-in-unit conversions. It supports two input modes (direct distance vs. laps per unit) and two distance units (miles vs. kilometers).

## Environment

Copy `.env.example` to `.env` and fill in values. Key variables: `PACER_TEAM_ID`, `MATCH_GIT_URL`, `MATCH_PASSWORD`, `FASTLANE_USER`, `FASTLANE_PASSWORD`.
