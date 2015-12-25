# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="https://github.com/breunigs/duplicity-acdcli.git"

inherit git-r3 python-r1

MY_PN="duplicity"

DESCRIPTION="Duplicity Backend using yadayada’s acd_cli project"
HOMEPAGE="https://github.com/breunigs/duplicity-acdcli"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
    app-backup/duplicity
"
RDEPEND="${DEPEND}"

src_install () {
	insinto /usr/lib64/python2.7/site-packages/${MY_PN}/backends
	doins amazonclouddrivebackend.py
}

