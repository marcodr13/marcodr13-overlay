# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit webapp

DESCRIPTION="The simpler media website CMS"
HOMEPAGE="http://www.zenphoto.org/"
SRC_URI="https://github.com/zenphoto/zenphoto/archive/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="exif +gd imagemagick"

RDEPEND="exif? ( dev-lang/php[exif] )
	imagemagick? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] ) )
	gd? ( || ( dev-lang/php[gd] dev-lang/php[gd-external] ) )
	|| ( dev-lang/php[mysql] dev-lang/php[mysqli] )"

REQUIRED_USE="|| ( gd imagemagick )"

S=${WORKDIR}/${PN}-${P}

src_install () {
	webapp_src_preinst

#	dohtml doc_files/README.html
#	dodoc doc_files/zenphoto_database_quick_reference.pdf
#	rm -f doc_files/README.html doc_files/License.txt doc_files/zenphoto_database_quick_reference.pdf
	touch "${D}/${MY_HTDOCSDIR}"/.htaccess

	insinto "${MY_HTDOCSDIR}"
	doins -r ${S}/*
#	keepdir "${MY_HTDOCSDIR}"/albums
#	keepdir "${MY_HTDOCSDIR}"/uploaded
#	keepdir "${MY_HTDOCSDIR}"/zp-data
#	keepdir "${MY_HTDOCSDIR}"/zp-core/setup

#	webapp_serverowned "${MY_HTDOCSDIR}"/.htaccess
#	webapp_serverowned "${MY_HTDOCSDIR}"/albums
#	webapp_serverowned "${MY_HTDOCSDIR}"/cache
#	webapp_serverowned "${MY_HTDOCSDIR}"/cache_html
#	webapp_serverowned "${MY_HTDOCSDIR}"/plugins
#	webapp_serverowned "${MY_HTDOCSDIR}"/uploaded
#	webapp_serverowned "${MY_HTDOCSDIR}"/zp-data
#	webapp_serverowned "${MY_HTDOCSDIR}"/zp-core/setup

#	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postupgrade_txt en "${FILESDIR}"/postupgrade-en.txt

	webapp_src_install
}

