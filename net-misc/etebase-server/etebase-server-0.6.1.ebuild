# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit eutils python-single-r1 systemd

DESCRIPTION="The Etebase server"
HOMEPAGE="https://www.etesync.com https://github.com/etesync/server"
SRC_URI="https://github.com/etesync/server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/server-${PV}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/django-3.1.1[${PYTHON_USEDEP},sqlite]
		<dev-python/django-4.0.0[${PYTHON_USEDEP},sqlite]
		>=dev-python/django-cors-headers-3.2.1[${PYTHON_USEDEP}]
		>=dev-python/djangorestframework-3.11.0[${PYTHON_USEDEP}]
		>=dev-python/drf-nested-routers-0.91[${PYTHON_USEDEP}]
		dev-python/httptools[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
	')
"

src_prepare() {
	sed -e "s:secret.txt:${EPREFIX}/var/lib/${PN}/&:" -e "s:db.sqlite3:${EPREFIX}/var/lib/${PN}/&:" -i "${S}/${PN}.ini.example" || die
	default
}

src_install() {
	dodoc -r ChangeLog.md ${PN}.ini.example example-configs README.md
	insinto /etc/${PN}
	newins ${PN}.ini.example ${PN}.ini
	rm -r ChangeLog.md ${PN}.ini.example example-configs icon.svg LICENSE README.md .github .gitignore || die
	python_fix_shebang manage.py
	insinto /usr/$(get_libdir)/${PN}
	doins -r .
	fperms 755 /usr/$(get_libdir)/${PN}/manage.py
	make_wrapper "${PN}" "./manage.py" "${EPREFIX}/usr/$(get_libdir)/${PN}"
	sed "s/@LIBDIR@/$(get_libdir)/" "${FILESDIR}/etebase.initd" > etebase.initd || die
	sed "s/@LIBDIR@/$(get_libdir)/" "${FILESDIR}/etebase.service" > etebase.service || die
	newinitd etebase.initd etebase
	newconfd "${FILESDIR}/etebase.confd" etebase
	systemd_dounit etebase.service
	keepdir /var/lib/${PN}
}
