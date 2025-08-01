# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 meson vala

DESCRIPTION="Manages, extracts and handles media art caches"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libmediaart"

LICENSE="LGPL-2.1+"
SLOT="2.0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="gtk gtk-doc +introspection qt6 test vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	^^ ( gtk qt6 )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	gtk? ( >=x11-libs/gdk-pixbuf-2.12:2 )
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
	qt6? ( dev-qt/qtbase:6[gui] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/gobject-introspection-common
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )
"

PATCHES=( "${FILESDIR}/${P}-qt6.patch" ) # TODO: upstream

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local image_library
	use gtk && image_library=gdk-pixbuf
	use qt6 && image_library=qt6

	local emesonargs=(
		-Dimage_library=${image_library}
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use test tests)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}
