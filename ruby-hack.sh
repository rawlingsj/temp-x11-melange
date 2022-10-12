set -e
set -x

apk add ruby

mkdir -p /home/build/melange-out
BUILD=/home/build/melange-out




pkgdir=$BUILD
pkgname=asciidoctor
pkgver=2.0.17
srcdir=/home/build

cd $srcdir

wget https://rubygems.org/downloads/asciidoctor-2.0.17.gem




package() {
	local gemdir="$(ruby -e 'puts Gem.default_dir')"

# --local \
# --ignore-dependencies \

	gem install \
		--install-dir "$pkgdir"$gemdir \
		--verbose \
		--no-document \
        --bindir "$pkgdir"/usr/bin \
		"$srcdir"/$pkgname-$pkgver.gem

	# rm -rf "$pkgdir"/$gemdir/cache

	# cd "$pkgdir"
	# local i; for i in "$pkgdir"/usr/lib/ruby/gems/*/bin/*; do
    #     echo $i
	# 	if [ -e "$i" ]; then
	# 		mkdir -p "$pkgdir"/usr/bin
	# 		ln -s /$i "$pkgdir"/usr/bin/
	# 	fi
	# done
}

package
