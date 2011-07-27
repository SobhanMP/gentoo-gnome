# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="User interface components for OpenPGP"
HOMEPAGE="http://www.gnome.org/projects/seahorse/index.html"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="debug doc +introspection libnotify test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

# Pull in libnotify-0.7 because it's controlled via an automagic ifdef
COMMON_DEPEND="
	>=gnome-base/gconf-2:2
	>=dev-libs/glib-2.10:2
	>=x11-libs/gtk+-2.90.0:3[introspection?]
	>=dev-libs/dbus-glib-0.72
	>=gnome-base/gnome-keyring-2.91.2

	>=app-crypt/gpgme-1
	|| (
		=app-crypt/gnupg-2.0*
		=app-crypt/gnupg-1.4* )

	introspection? ( >=dev-libs/gobject-introspection-0.6.4 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=app-text/gnome-doc-utils-0.3.2
	>=app-text/scrollkeeper-0.3
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.9 )
"
# Before 3.1.4, libcryptui was part of seahorse
RDEPEND="${COMMON_DEPEND}
	!!<app-crypt/seahorse-3.1.4
"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-scrollkeeper
		--disable-update-mime-database
		$(use_enable debug)
		$(use_enable introspection)
		$(use_enable libnotify)
		$(use_enable test tests)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	# FIXME: Do not mess with CFLAGS with USE="debug"
	sed -e '/CFLAGS="$CFLAGS -g -O0/d' \
		-e 's/-Werror//' \
		-i configure.ac configure || die "sed failed"

	# Prevent file collisions with app-crypt/seahorse, will be in next release
	# https://bugzilla.gnome.org/show_bug.cgi?id=655291
	epatch "${FILESDIR}/${P}-seahorse-file-collisions.patch"
	mv data/seahorse.schemas.in data/cryptui.schemas.in || die "mv failed"
	[[ ${PV} = 9999 ]] || eautoreconf

	gnome2_src_prepare
}
