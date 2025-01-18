# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_12 )

inherit python-single-r1 systemd wrapper

DESCRIPTION="The Etebase server"
HOMEPAGE="https://www.etesync.com https://github.com/etesync/server"
SRC_URI="https://github.com/etesync/server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/server-${PV}"

RDEPEND="
	acct-group/etebase
	acct-user/etebase
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/aiofiles-23.2.1[${PYTHON_USEDEP}]
		>=dev-python/django-4.0.0[${PYTHON_USEDEP},sqlite]
		<dev-python/django-5.0.0[${PYTHON_USEDEP},sqlite]
		>=dev-python/fastapi-0.104.0[${PYTHON_USEDEP}]
		>=dev-python/httptools-0.6.1[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.8[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/python-dotenv-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytz-2022.6[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/redis-4.4.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.30.1[${PYTHON_USEDEP}]
		>=dev-python/uvloop-0.19.0[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.4[${PYTHON_USEDEP}]
	')
"

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
	newinitd etebase.initd-r1 etebase
	newconfd "${FILESDIR}/etebase.confd" etebase
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/etebase.logrotate etebase
	systemd_dounit etebase.service
	keepdir /var/lib/${PN}
}
