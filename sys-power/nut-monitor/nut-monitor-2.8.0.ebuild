# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11} )

inherit desktop python-single-r1

MY_P=nut-${PV}

DESCRIPTION="GUI to manage devices connected a NUT server"
HOMEPAGE="https://www.networkupstools.org/"
SRC_URI="https://networkupstools.org/source/${PV%.*}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/PyQt5[${PYTHON_USEDEP}]')"

S="${WORKDIR}/${MY_P}/scripts/python"

PATCHES=( "${FILESDIR}/${P}-fix-paths.patch" )

src_install() {
	for f in module/PyNUT.py app/NUT-Monitor-py3qt5; do
		{ echo "#!${PYTHON}"; cat "$f.in"; } >"$f" || die
		python_fix_shebang "$f"
	done
	python_domodule module/PyNUT.py
	python_doscript app/NUT-Monitor-py3qt5

	insinto /usr/share/NUT-Monitor/ui
	doins app/ui/*.ui

	insinto /usr/share/NUT-Monitor/pixmaps
	doins app/pixmaps/*

	for size in 48x48 64x64 256x256 scalable; do
		doicon -s "${size}" "app/icons/${size}/${PN}".??g
	done
	domenu "app/${PN}-py3qt5.desktop"
}
