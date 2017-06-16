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
	>=dev-util/cmake-3.0.0
	>=net-dns/unbound-1.4.21
	>=net-libs/miniupnpc-2.0
	>=net-libs/ldns-1.6.17
	>=dev-libs/libevent-2.0.22
	>=dev-cpp/gtest-1.7.0
	>=dev-libs/boost-1.58.0
	>=sys-libs/db-4.8
	sys-libs/libunwind
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
	dobin  "${S}_build/bin/monerod"
	dobin  "${S}_build/bin/monero-blockchain-export"
	dobin  "${S}_build/bin/monero-blockchain-import"
	dobin  "${S}_build/bin/monero-utils-deserialize"
	dobin  "${S}_build/bin/monero-wallet-cli"
	dobin  "${S}_build/bin/monero-wallet-rpc"

	insinto /etc/monero
	newins  "${FILESDIR}/monerod.conf" monerod.conf
	fowners monero:monero /etc/monero/monerod.conf
	fperms  600 /etc/monero/monerod.conf

#	newconfd "${FILESDIR}/monerod.conf" monerod
#	newinitd "${FILESDIR}/monerod.runscript" monerod
	systemd_dounit "${FILESDIR}/monerod.service"

	keepdir /var/lib/monero/.bitmonero
	fperms  700 /var/lib/monero
	fowners monero:monero /var/lib/monero/
	fowners monero:monero /var/lib/monero/.bitmonero
	dosym   /etc/monero/monerod.conf /var/lib/monero/.bitmonero/monerod.conf

	dodoc README.md
}
