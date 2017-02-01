# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user cmake-utils systemd

DESCRIPTION="the secure, private, untraceable cryptocurrency"
HOMEPAGE="https://getmonero.org/"
SRC_URI="https://github.com/monero-project/monero/archive/v${PV}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-devel/gcc-4.7.3
	>=dev-util/cmake-2.8.7
	>=net-dns/unbound-1.4.21
	>=dev-libs/libevent-2.0.22
	>=dev-cpp/gtest-1.7.0
	>=dev-libs/boost-1.58.0
	>=sys-libs/db-4.8
	dev-libs/openssl:0[-bindist]"

pkg_setup() {
	enewgroup monero
	enewuser monero -1 -1 /var/lib/monero "monero"
}

src_configure() {
	# General function for configuring with cmake. Default behaviour is to start an out-of-source build.
	cmake-utils_src_configure
}

src_install() {
	newbin "${S}_build/bin/bitmonerod" monerod
	dobin  "${S}_build/bin/connectivity_tool"
	dobin  "${S}_build/bin/simpleminer"
	dobin  "${S}_build/bin/simplewallet"

	insinto /etc/monero
	newins  "${FILESDIR}/bitmonero.conf" monero.conf
	fowners monero:monero /etc/monero/monero.conf
	fperms  600 /etc/monero/monero.conf

	newconfd "${FILESDIR}/monerod.conf" monerod
	newinitd "${FILESDIR}/monerod.runscript" monerod
	systemd_dounit "${FILESDIR}/monerod.service"

	keepdir /var/lib/monero/.bitmonero
	fperms  700 /var/lib/monero
	fowners monero:monero /var/lib/monero/
	fowners monero:monero /var/lib/monero/.bitmonero
	dosym   /etc/monero/monero.conf /var/lib/monero/.bitmonero/bitmonero.conf

	dodoc ReleaseNotes.txt README.md
}
