# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cheese/cheese-3.4.2.ebuild,v 1.1 2012/05/24 08:04:54 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://www.gnome.org/projects/cheese/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+introspection sendto test"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

COMMON_DEPEND="
	>=dev-libs/glib-2.28:2
	>=dev-libs/libgee-0.6.3:0
	>=x11-libs/gtk+-3.4.4:3[introspection?]
	>=x11-libs/cairo-1.10
	>=x11-libs/pango-1.28.0
	>=sys-fs/udev-171[gudev]
	>=gnome-base/gnome-desktop-2.91.6:3
	>=gnome-base/librsvg-2.32.0:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=media-libs/clutter-1.10:1.0[introspection?]
	>=media-libs/clutter-gtk-0.91.8:1.0
	>=media-libs/clutter-gst-1.9:2.0

	media-video/gnome-video-effects
	x11-libs/gdk-pixbuf:2[jpeg,introspection?]
	x11-libs/libX11
	x11-libs/libXtst

	media-libs/gstreamer:1.0[introspection?]
	media-libs/gst-plugins-base:1.0[introspection?,ogg,pango,theora,vorbis,X]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-bad:1.0
	media-libs/gst-plugins-good:1.0

	media-plugins/gst-plugins-jpeg:1.0
	media-plugins/gst-plugins-v4l2:1.0
	media-plugins/gst-plugins-vpx:1.0

	sendto? ( >=gnome-extra/nautilus-sendto-2.91 )"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxml2:2
	>=dev-util/gtk-doc-1.14
	>=dev-util/intltool-0.50
	dev-util/itstool
	virtual/pkgconfig
	x11-proto/xf86vidmodeproto
	test? ( dev-libs/glib:2[utils] )"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		dev-lang/vala:0.18
		doc? ( >=dev-util/gtk-doc-1.14 )"
fi

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		GST_INSPECT=$(type -P true)
		VALAC=$(type -P valac-0.18)
		$(use_enable introspection)
		--disable-lcov
		--disable-static"
	[[ ${PV} != 9999 ]] && G2CONF="${G2CONF} ITSTOOL=$(type -P true)"

	gnome2_src_configure
}

src_compile() {
	# Clutter-related sandbox violations when USE="doc introspection" and
	# FEATURES="-userpriv" (see bug #385917).
	unset DISPLAY
	gnome2_src_compile
}

src_test() {
	Xemake check
}

pkg_preinst() {
	gnome2_pkg_preinst
	preserve_old_lib /usr/$(get_libdir)/libcheese.so.3 \
		/usr/$(get_libdir)/libcheese-gtk.so.21
}

pkg_postinst() {
	gnome2_pkg_postinst
	preserve_old_lib_notify /usr/$(get_libdir)/libcheese.so.3 \
		/usr/$(get_libdir)/libcheese-gtk.so.21
}