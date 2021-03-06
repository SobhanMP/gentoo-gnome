# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib
if [[ ${PV} = 9999 ]]; then
	inherit git-2 gnome2-live
fi

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="3/4" # subslot = libgnome-desktop-3 soname version
IUSE="+introspection"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
fi

# cairo[X] needed for gnome-bg
COMMON_DEPEND="
	>=dev-libs/glib-2.33.3:2
	>=x11-libs/gdk-pixbuf-2.21.3:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[introspection?]
	>=x11-libs/libXext-1.1
	>=x11-libs/libXrandr-1.3
	x11-libs/cairo:=[X]
	x11-libs/libxkbfile
	x11-libs/libX11
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	introspection? ( >=dev-libs/gobject-introspection-0.9.7 )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-desktop-2.32.1-r1:2[doc]
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	x11-proto/xproto
	>=x11-proto/randrproto-1.2
	virtual/pkgconfig
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		doc? ( >=dev-util/gtk-doc-1.4 )
		app-text/yelp-tools"
fi

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

src_unpack() {
	gnome2_src_unpack

	if [[ ${PV} = 9999 ]]; then
		# pnp.ids are only provided with the gnome-desktop tarball;
		# for the live version, we have to get them from hwdata git
		unset gnome_desktop_LIVE_BRANCH
		unset gnome_destkop_LIVE_COMMIT
		unset gnome_desktop_LIVE_REPO
		unset EGIT_BRANCH
		unset EGIT_COMMIT
		unset EGIT_DIR
		unset EGIT_MASTER
		EGIT_PROJECT="gnome-desktop_hwdata"
		EGIT_REPO_URI="git://git.fedorahosted.org/hwdata.git"
		EGIT_SOURCEDIR="${WORKDIR}/hwdata"
		git-2_src_unpack
		ln -sf "${WORKDIR}/hwdata/pnp.ids" "${S}/libgnome-desktop/" ||
			die "ln -sf failed"
	fi
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	# Note: do *not* use "--with-pnp-ids-path" argument. Otherwise, the pnp.ids
	# file (needed by other packages such as >=gnome-settings-daemon-3.1.2)
	# will not get installed in ${pnpdatadir} (/usr/share/libgnome-desktop-3.0).
	G2CONF="${G2CONF}
		--disable-static
		--with-gnome-distributor=Gentoo
		--enable-desktop-docs
		$(use_enable introspection)"
	if [[ ${PV} = 9999 ]]; then
		G2CONF="${G2CONF} $(use_enable doc gtk-doc)"
	else
		G2CONF="${G2CONF} ITSTOOL=$(type -P true)"
	fi

	gnome2_src_prepare
}

pkg_preinst() {
	gnome2_pkg_preinst
	preserve_old_lib /usr/$(get_libdir)/libgnome-desktop-3.so.2
}

pkg_postinst() {
	gnome2_pkg_preinst
	preserve_old_lib_notify /usr/$(get_libdir)/libgnome-desktop-3.so.2
}
