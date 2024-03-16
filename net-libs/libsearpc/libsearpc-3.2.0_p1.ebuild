# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

# Upstream is moving tags repeatedly, then we use commit hash.
RELEASE_COMMIT="54145b03f4240222e336a9a2f402e93facefde65" #tag v3.2_latest

inherit autotools python-single-r1

DESCRIPTION="Simple C language RPC framework"
HOMEPAGE="https://github.com/haiwen/libsearpc/ https://seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/${RELEASE_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.26.0
	>=dev-libs/jansson-2.2.1:="
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/simplejson[${PYTHON_USEDEP}]
	')"

src_prepare() {
	default
	sed -i -e "s/(DESTDIR)//" ${PN}.pc.in || die
	eautoreconf
}

src_install() {
	default
	# Remove unnecessary .la files
	find "${ED}" -name '*.la' -delete || die
}
