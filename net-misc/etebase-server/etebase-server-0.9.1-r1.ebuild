# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )

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
		>=dev-python/aiofiles-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/django-3.2.12[${PYTHON_USEDEP},sqlite]
		<dev-python/django-4.0.0[${PYTHON_USEDEP},sqlite]
		>=dev-python/fastapi-0.75.0[${PYTHON_USEDEP}]
		>=dev-python/httptools-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/python-dotenv-0.19.2[${PYTHON_USEDEP}]
		>=dev-python/pytz-2022.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/redis-py-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.17.6[${PYTHON_USEDEP}]
		>=dev-python/uvloop-0.16.0[${PYTHON_USEDEP}]
		>=dev-python/watchgod-0.8.1[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.2[${PYTHON_USEDEP}]
	')
"

# https://github.com/etesync/server/pull/151
PATCHES=("${FILESDIR}/${P}-replace-aioredis-with-redis-py.patch")

src_prepare() {
	sed -e "s:secret.txt:${EPREFIX}/var/lib/${PN}/&:" -e "s:db.sqlite3:${EPREFIX}/var/lib/${PN}/&:" -i "${S}/${PN}.ini.example" || die
	default
}

src_install() {
	dodoc ChangeLog.md ${PN}.ini.example README.md
	insinto /etc/${PN}
	newins ${PN}.ini.example ${PN}.ini
	rm -r ChangeLog.md ${PN}.ini.example icon.svg LICENSE README.md .github .gitignore || die
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
