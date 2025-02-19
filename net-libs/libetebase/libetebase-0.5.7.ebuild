# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	aligned@0.4.2
	ansi_term@0.12.1
	as-slice@0.2.1
	atty@0.2.14
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.21.7
	bitflags@1.3.2
	bitflags@2.8.0
	bumpalo@3.17.0
	byteorder@1.5.0
	bytes@1.10.0
	cbindgen@0.14.3
	cc@1.2.13
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	clap@2.34.0
	core-foundation-sys@0.8.7
	core-foundation@0.9.4
	cvt@0.1.2
	displaydoc@0.2.5
	ed25519@1.5.3
	encoding_rs@0.8.35
	equivalent@1.0.1
	errno@0.3.10
	etebase@0.6.0
	fastrand@2.3.0
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.1
	fs_at@0.2.1
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-io@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	getrandom@0.3.1
	gimli@0.31.1
	h2@0.3.26
	hashbrown@0.15.2
	heck@0.3.3
	hermit-abi@0.1.19
	http-body@0.4.6
	http@0.2.12
	httparse@1.10.0
	httpdate@1.0.3
	hyper-tls@0.5.0
	hyper@0.14.32
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@2.7.1
	ipnet@2.11.0
	itoa@1.0.14
	js-sys@0.3.77
	libc@0.2.169
	libsodium-sys@0.2.7
	linux-raw-sys@0.4.15
	litemap@0.7.4
	log@0.4.25
	memchr@2.7.4
	mime@0.3.17
	miniz_oxide@0.8.4
	mio@1.0.3
	native-tls@0.2.13
	nix@0.29.0
	normpath@1.3.0
	num-traits@0.2.19
	object@0.36.7
	once_cell@1.20.3
	openssl-macros@0.1.1
	openssl-probe@0.1.6
	openssl-sys@0.9.105
	openssl@0.10.70
	paste@1.0.15
	percent-encoding@2.3.1
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.31
	proc-macro2@1.0.93
	quote@1.0.38
	remove_dir_all@0.8.4
	reqwest@0.11.27
	rmp-serde@1.3.0
	rmp@0.8.14
	rustc-demangle@0.1.24
	rustix@0.38.44
	rustls-pemfile@1.0.4
	rustversion@1.0.19
	ryu@1.0.19
	same-file@1.0.6
	schannel@0.1.27
	security-framework-sys@2.14.0
	security-framework@2.11.1
	serde@1.0.217
	serde_bytes@0.11.15
	serde_derive@1.0.217
	serde_json@1.0.138
	serde_repr@0.1.19
	serde_urlencoded@0.7.1
	shlex@1.3.0
	signature@1.6.4
	slab@0.4.9
	smallvec@1.13.2
	socket2@0.5.8
	sodiumoxide@0.2.7
	stable_deref_trait@1.2.0
	strsim@0.8.0
	syn@1.0.109
	syn@2.0.98
	sync_wrapper@0.1.2
	synstructure@0.13.1
	system-configuration-sys@0.5.0
	system-configuration@0.5.1
	tempfile@3.16.0
	textwrap@0.11.0
	tinystr@0.7.6
	tokio-native-tls@0.3.1
	tokio-util@0.7.13
	tokio@1.43.0
	toml@0.5.11
	tower-service@0.3.3
	tracing-core@0.1.33
	tracing@0.1.41
	try-lock@0.2.5
	unicode-ident@1.0.16
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	vcpkg@0.2.15
	vec_map@0.8.2
	walkdir@2.5.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-futures@0.4.50
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	web-sys@0.3.77
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winreg@0.50.0
	wit-bindgen-rt@0.33.0
	write16@1.0.0
	writeable@0.5.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zerovec-derive@0.10.3
	zerovec@0.10.4
"

inherit cargo

DESCRIPTION="C library for etebase"
HOMEPAGE="https://github.com/etesync/libetebase"
SRC_URI="
        https://github.com/etesync/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
        $(cargo_crate_uris)
"
RESTRICT="mirror"
LICENSE="Apache-2.0
        || ( Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT )
        || ( Apache-2.0 Boost-1.0 )
        || ( Apache-2.0 MIT )
        || ( Apache-2.0 MIT ZLIB )
        BSD
        MIT
        || ( MIT Unlicense )
        MPL-2.0
        ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}"

src_compile() {
        cargo_src_compile
        emake pkgconfig
}

src_install() {
        insinto /usr/$(get_libdir)/pkgconfig
        doins target/etebase.pc
        insinto /usr/$(get_libdir)/cmake/Etebase
        doins EtebaseConfig.cmake
        doheader target/etebase.h
        insinto /usr/$(get_libdir)
        doins target/$(usex debug "debug" "release")/${PN}.so
        # for that dumb evolution plugin
        dosym ${PN}.so "${EPREFIX}/usr/$(get_libdir)/${PN}.so.0"
}
