# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

GITHUB_USER="Rudde"
GITHUB_REPO="mktorrent"
GITHUB_TAG="${PV}"

NAME="mktorrent"
DESCRIPTION="Simple command line utility to create BitTorrent metainfo files"
HOMEPAGE="https://github.com/Rudde/mktorrent"

SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/v${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads +ssl debug"

RDEPEND="ssl? ( dev-libs/openssl:0 )"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC
	MAKEPARAM="USE_LONG_OPTIONS=1"
	MAKEPARAM="${MAKEPARAM} USE_LARGE_FILES=1"
	use debug && MAKEPARAM="${MAKEPARAM} DEBUG=1"
	use ssl && MAKEPARAM="${MAKEPARAM} USE_OPENSSL=1"
	use threads && MAKEPARAM="${MAKEPARAM} USE_PTHREADS=1"

	emake ${MAKEPARAM}
}

src_install() {
	dobin ${PN}
	dodoc README
}
