# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

DESCRIPTION="A Cython interface to the hidapi from https://github.com/signal11/hidapi"
HOMEPAGE="https://github.com/trezor/cython-hidapi"
MY_PV=${PV/_p/.post}
MY_PN="hidapi"
MY_P=${MY_PN}-${MY_PV}
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="|| ( BSD GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/cython"
BDEPEND=""

S="${WORKDIR}"/${MY_P}

