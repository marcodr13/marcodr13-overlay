# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Backblaze B2 Command Line Tool and API"
HOMEPAGE="https://github.com/Backblaze/b2 https://pypi.org/project/b2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc test"

DEPEND="
	>=dev-python/futures-3.0.5[$(python_gen_usedep 'python2*')]
	dev-python/setuptools[${PYTHON_USEDEP}]
	<dev-python/arrow-0.12.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/logfury[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}] "

RDEPEND="${DEPEND}"

python_prepare_all() {
	# Don't package test
	sed -i -e "s/'tests'/'test'/" setup.py || die
	# Rename executable to not clash with Boost
	sed -i -e "s/'b2=b2.console_tool:main'/'b2_bb=b2.console_tool:main'/" setup.py || die
	distutils-r1_python_prepare_all
}
