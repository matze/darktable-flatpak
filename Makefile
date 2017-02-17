include Makefile.config

release: repo org.darktable.Darktable.json
	flatpak-builder --force-clean --repo=repo --ccache --gpg-sign=${GPG_KEY} darktable org.darktable.Darktable.json
	flatpak build-update-repo --generate-static-deltas --gpg-sign=${GPG_KEY} repo

bundle:
	flatpak build-bundle repo darktable.flatpak org.darktable.Darktable
	rm -f darktable.flatpak.sig
	gpg --sign-with ${GPG_KEY} --output darktable.flatpak.sig --detach-sign darktable.flatpak

repo:
	ostree init --mode=archive-z2 --repo=repo

darktable.flatpakref: darktable.flatpakref.in 
	sed -e 's|@REPO_URL@|${REPO_URL}|g' -e 's|@GPG@|$(shell gpg2 --export ${GPG_KEY} | base64 | tr -d '\n')|' $< > $@
