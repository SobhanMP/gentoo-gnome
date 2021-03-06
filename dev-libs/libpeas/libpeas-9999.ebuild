# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils gnome2 multilib python-single-r1 virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="A GObject plugins library"
HOMEPAGE="http://developer.gnome.org/libpeas/stable/"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="gjs +gtk glade +python seed"
if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~x86 ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
fi

RDEPEND=">=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-0.10.1
	gjs? ( >=dev-libs/gjs-1.31.11 )
	glade? ( >=dev-util/glade-3.9.1:3.10 )
	gtk? ( >=x11-libs/gtk+-3:3[introspection] )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.0.0:3[${PYTHON_USEDEP}] )
	seed? ( >=dev-libs/seed-2.91.91 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND} doc? ( >=dev-util/gtk-doc-1.11 )"
fi

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	G2CONF="${G2CONF}
		$(use_enable gjs)
		$(use_enable glade glade-catalog)
		$(use_enable gtk)
		$(use_enable python)
		$(use_enable seed)
		--disable-deprecation
		--disable-static"
	# Wtf, --disable-gcov, --enable-gcov=no, --enable-gcov, all enable gcov
	# What do we do about gdb, valgrind, gcov, etc?

	gnome2_src_prepare
}

src_test() {
	# FIXME: Tests fail because of some bug involving Xvfb and Gtk.IconTheme
	# DO NOT REPORT UPSTREAM, this is not a libpeas bug.
	# To reproduce:
	# >>> from gi.repository import Gtk
	# >>> Gtk.IconTheme.get_default().has_icon("gtk-about")
	# This should return True, it returns False for Xvfb
	Xemake check
}
