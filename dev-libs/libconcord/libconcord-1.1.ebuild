# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 perl-app

MY_PN="concordance"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Library for programming Logitech Harmony universal remote controls"
HOMEPAGE="http://phildev.net/concordance/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +udev consolekit perl python +usbnet-headers"

DEPEND="dev-libs/hidapi
		dev-libs/libzip
		consolekit? ( sys-auth/consolekit )
		perl? ( virtual/perl-Module-Build
				dev-lang/swig )
"
#		udev? ( sys-fs/udev )

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/libconcord"

src_prepare() {
	if ! use usbnet-headers; then
    	epatch "${FILESDIR}"/usbnet_headers_remove.patch
	fi
}

src_configure() {

	myconf="--sysconfdir=/lib"

	if use debug; then
		myconf="${myconf} CPPFLAGS=-D_DEBUG"
	fi

	econf ${myconf}
}

src_compile() {
	emake || die

	if use consolekit; then
		emake consolekit || die
	elif use udev; then
		emake udev || die
	fi

	if use perl; then
		cd "${S}/bindings/perl"
		swig -perl5 concord.i
		perl-app_src_configure
	fi

	if use python; then
		cd "${S}/bindings/python"
		distutils-r1_src_compile
	fi
}

src_install() {

	dodoc ../{Changelog,CodingStyle,TODO,SubmittingPatches} README
	insinto /usr/share/doc/${P}/specs
	doins ../specs/*

	emake DESTDIR="${D}" install || die

	if use consolekit; then
		emake DESTDIR="${D}" install_consolekit || die
	elif use udev; then
		emake DESTDIR="${D}" install_udev || die
	fi

	if use perl; then
		cd bindings/perl
		emake DESTDIR="${D}" install || die
	fi

	if use python; then
		cd "${S}/bindings/python"
		distutils-r1_src_install
	fi
}
