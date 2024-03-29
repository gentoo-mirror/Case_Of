# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	bumpalo-3.9.1
	byteorder-1.4.3
	bytes-1.1.0
	cbindgen-0.14.3
	cc-1.0.73
	cfg-if-1.0.0
	clap-2.34.0
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	crossbeam-channel-0.5.4
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.8
	crossbeam-utils-0.8.8
	ed25519-1.4.1
	either-1.6.1
	encoding_rs-0.8.30
	etebase-0.5.3
	fastrand-1.7.0
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-io-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	h2-0.3.12
	hashbrown-0.11.2
	heck-0.3.3
	hermit-abi-0.1.19
	http-0.2.6
	http-body-0.4.4
	httparse-1.6.0
	httpdate-1.0.2
	hyper-0.14.18
	hyper-tls-0.5.0
	idna-0.2.3
	indexmap-1.8.1
	instant-0.1.12
	ipnet-2.4.0
	itoa-1.0.1
	js-sys-0.3.56
	lazy_static-1.4.0
	libc-0.2.121
	libsodium-sys-0.2.7
	log-0.4.16
	matches-0.1.9
	memchr-2.4.1
	memoffset-0.6.5
	mime-0.3.16
	mio-0.8.2
	miow-0.3.7
	native-tls-0.2.10
	ntapi-0.3.7
	num-traits-0.2.14
	num_cpus-1.13.1
	once_cell-1.10.0
	openssl-0.10.38
	openssl-probe-0.1.5
	openssl-sys-0.9.72
	percent-encoding-2.1.0
	pin-project-lite-0.2.8
	pin-utils-0.1.0
	pkg-config-0.3.25
	proc-macro2-1.0.36
	quote-1.0.17
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.13
	remove_dir_all-0.5.3
	remove_dir_all-0.6.1
	reqwest-0.11.10
	rmp-0.8.10
	rmp-serde-1.0.0
	ryu-1.0.9
	same-file-1.0.6
	schannel-0.1.19
	scopeguard-1.1.0
	security-framework-2.6.1
	security-framework-sys-2.6.1
	serde-1.0.136
	serde_bytes-0.11.5
	serde_derive-1.0.136
	serde_json-1.0.79
	serde_repr-0.1.7
	serde_urlencoded-0.7.1
	signature-1.5.0
	slab-0.4.5
	socket2-0.4.4
	sodiumoxide-0.2.7
	strsim-0.8.0
	syn-1.0.90
	tempfile-3.3.0
	textwrap-0.11.0
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	tokio-1.17.0
	tokio-native-tls-0.3.0
	tokio-util-0.6.9
	toml-0.5.8
	tower-service-0.3.1
	tracing-0.1.32
	tracing-core-0.1.23
	try-lock-0.2.3
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	url-2.2.2
	vcpkg-0.2.15
	vec_map-0.8.2
	walkdir-2.3.2
	want-0.3.0
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.79
	wasm-bindgen-backend-0.2.79
	wasm-bindgen-futures-0.4.29
	wasm-bindgen-macro-0.2.79
	wasm-bindgen-macro-support-0.2.79
	wasm-bindgen-shared-0.2.79
	web-sys-0.3.56
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	winreg-0.10.1
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
