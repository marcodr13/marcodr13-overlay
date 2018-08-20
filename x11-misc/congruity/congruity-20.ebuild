# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 xdg-utils

DESCRIPTION="GUI application for programming Logitech Harmony remote controls"
HOMEPAGE="http://sourceforge.net/projects/congruity/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.bz2"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/wxpython:3.0
		>=dev-libs/libconcord-1.1[python]
		dev-python/suds"
RDEPEND="${DEPEND}"

python_install() {
	distutils-r1_python_install --skip-update-desktop-db
}

pkg_postinst() {
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
}

pkg_postrm() {
    xdg_desktop_database_update
    xdg_mimeinfo_database_update
}

