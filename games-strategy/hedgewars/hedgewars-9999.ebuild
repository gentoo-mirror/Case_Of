# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake
CMAKE_BUILD_TYPE=RelWithDebInfo
LUA_COMPAT=( lua5-1 )

inherit cmake lua-single mercurial xdg-utils

DESCRIPTION="A turn-based strategy, artillery, action and comedy game"
HOMEPAGE="https://www.hedgewars.org/"
EHG_REPO_URI="http://hg.hedgewars.org/hedgewars/"
LICENSE="GPL-2 Apache-2.0 FDL-1.3"
SLOT="0"
KEYWORDS=""
IUSE="server pas2c"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
	x86? ( pas2c )
"

QA_FLAGS_IGNORED="/usr/bin/hwengine" # pascal sucks
QA_PRESTRIPPED="/usr/bin/hwengine" # pascal sucks

# qtcore:5= - depends on private header
DEPEND="${LUA_DEPS}
	>=dev-games/physfs-3.0.1
	dev-qt/qtcore:5=
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libpng:0=
	media-libs/libsdl2:=
	media-libs/sdl2-image:=
	media-libs/sdl2-mixer:=[vorbis]
	media-libs/sdl2-net:=
	media-libs/sdl2-ttf:=
	sys-libs/zlib:=
	!pas2c? (
		media-video/ffmpeg:=
	)"
BDEPEND="
	dev-qt/linguist-tools:5
	server? (
		>=dev-lang/ghc-6.10
		dev-haskell/entropy
		dev-haskell/hslogger
		>=dev-haskell/mtl-2
		>=dev-haskell/network-2.3
		dev-haskell/random
		dev-haskell/regex-tdfa
		dev-haskell/sandi
		dev-haskell/sha
		dev-haskell/vector
		dev-haskell/utf8-string
		dev-haskell/yaml
		>=dev-haskell/zlib-0.5.3
	)
	!pas2c? ( >=dev-lang/fpc-2.4 )
	pas2c? (
		>=dev-lang/ghc-6.10
		dev-haskell/parsec
	)"
RDEPEND="${DEPEND}
	app-arch/xz-utils
	>=media-fonts/dejavu-2.28
	|| (
		media-fonts/wqy-zenhei
		media-fonts/wqy-microhei
	)"

PATCHES=( "${FILESDIR}/${PN}-cmake_lua_version.patch" )

src_configure() {
	local mycmakeargs=(
		-DMINIMAL_FLAGS=ON
		-DDATA_INSTALL_DIR="${EPREFIX}/usr/share/${PN}"
		-Dtarget_binary_install_dir="${EPREFIX}/usr/bin"
		-Dtarget_library_install_dir="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_BUILD_TYPE=RelWithDebInfo
		-DNOSERVER=$(usex server FALSE TRUE)
		-DBUILD_ENGINE_C=$(usex pas2c ON OFF)
		-DNOVIDEOREC=$(usex pas2c TRUE FALSE)
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DPHYSFS_SYSTEM=ON
		# Need to tell the build system where the fonts are located
		# as it uses PhysFS' symbolic link protection mode which
		# prevents us from symlinking the fonts into the right directory
		#   https://hg.hedgewars.org/hedgewars/rev/76ad55807c24
		#   https://icculus.org/physfs/docs/html/physfs_8h.html#aad451d9b3f46f627a1be8caee2eef9b7
		-DFONTS_DIRS="${EPREFIX}/usr/share/fonts/wqy-zenhei;${EPREFIX}/usr/share/fonts/dejavu"
		# upstream sets RPATH that leads to weird breakage
		# https://bugzilla.redhat.com/show_bug.cgi?id=1200193
		-DCMAKE_SKIP_RPATH=ON
		-DLUA_VERSION=$(lua_get_version)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman man/${PN}.6
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
