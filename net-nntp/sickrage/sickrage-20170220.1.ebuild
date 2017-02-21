# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils user python-single-r1

DESCRIPTION="SickRage - Automatic Video Library Manager for TV Shows"
HOMEPAGE="http://sickrage.github.io/"

LICENSE="GPL-3" # only
SLOT="0"
IUSE=""

if [[ ${PV} != *9999* ]]; then
    MY_P="${PV:0:4}.${PV:4:2}.${PV:6:2}-${PV:9:1}"

	SRC_URI="https://github.com/SickRage/SickRage/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/SickRage-${MY_P}"
#    DOCS=( RELEASE_NOTES )
else
    EGIT_REPO_URI="git://github.com/SickRage/SickRage.git"
    inherit git-r3
fi


DEPEND="${PYTHON_DEPS}"
RDEPEND="
	dev-python/cheetah
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	#python_set_active_version 2
	python-single-r1_pkg_setup

	# Create sickrage group
	enewgroup ${PN}
	# Create sickrage user, put in sickrage group
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_install() {
	dodoc readme.md

	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	# Location of log and data files
	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	keepdir /var/{lib/${PN}/{cache,download},log/${PN}}
	fowners -R ${PN}:${PN} /var/{lib/${PN}/{cache,download},log/${PN}}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}
	doins "${FILESDIR}/${PN}.ini"

	# Rotation of log files
	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	## weird stuff ;-)
	# last_commit=$(git rev-parse HEAD)
	# echo ${last_commit} > version.txt

	insinto /usr/share/${PN}
	doins -r contrib gui lib locale sickbeard sickrage tests SickBeard.py 

	python_optimize /usr/share/${PN}
}

pkg_postinst() {
	# we need to remove .git which old ebuild installed
	if [[ -d "/usr/share/${PN}/.git" ]] ; then
		ewarn "stale files from previous ebuild detected"
		ewarn "/usr/share/${PN}/.git removed."
		ewarn "To ensure proper operation, you should unmerge package and remove directory /usr/share/${PN} and then emerge package again"
		ewarn "Sorry for the inconvenience"
		rm -Rf "/usr/share/${PN}/.git"
	fi

	elog "SickRage has been installed with data directories in /var/lib/${PN}"
	elog
	elog "New user/group ${PN}/${PN} has been created"
	elog
	elog "Config file is located in /etc/${PN}/${PN}.ini"
	elog
	elog "Please configure /etc/conf.d/${PN} before starting as daemon!"
	elog
	elog "Start with ${ROOT}etc/init.d/${PN} start"
	elog "Visit http://<host ip>:8081 to configure SickRage"
	elog "Default web username/password : sickrage/secret"
	elog
}

#pkg_postrm() {
#	python_mod_cleanup /usr/share/${PN}
#}
