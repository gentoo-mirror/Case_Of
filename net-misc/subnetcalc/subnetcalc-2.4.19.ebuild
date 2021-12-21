# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="IP address calculator"
HOMEPAGE="https://www.uni-due.de/~be0001/subnetcalc/ https://github.com/dreibh/subnetcalc"
SRC_URI="https://www.uni-due.de/~be0001/${PN}/download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="dev-libs/geoip"
DEPEND="${RDEPEND}"
