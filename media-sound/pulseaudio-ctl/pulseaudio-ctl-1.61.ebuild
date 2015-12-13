# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Control pulseaudio volume from the shell or mapped to keyboard shortcuts. No need for alsa-utils."
HOMEPAGE="https://github.com/graysky2/pulseaudio-ctl"
SRC_URI="https://github.com/graysky2/pulseaudio-ctl/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=media-sound/pulseaudio-4.0"
RDEPEND="${DEPEND}"

