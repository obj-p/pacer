.PHONY: all clean generate build distribute serve certs ca

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

certs:
	@mkdir -p ~/.local/share/caddy-certs
	@mkcert -cert-file ~/.local/share/caddy-certs/${PACER_DISTRIBUTION_DOMAIN}.crt -key-file ~/.local/share/caddy-certs/${PACER_DISTRIBUTION_DOMAIN}.key ${PACER_DISTRIBUTION_DOMAIN}

ca:
	@mkdir -p dist
	@cp "$$(mkcert -CAROOT)/rootCA.pem" dist/ca.pem

serve:
	@caddy run --config Caddyfile
