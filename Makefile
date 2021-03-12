serve:
	bundle exec jekyll serve --open-url

drafts:
	bundle exec jekyll serve --drafts --open-url

install:
	bundle install

nix:
	nix-shell -p bundler -p bundix --run 'bundler update; bundler lock; bundler package --no-install --path vendor; bundix; rm -rf vendor'
