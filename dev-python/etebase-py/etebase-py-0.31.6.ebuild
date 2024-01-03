# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11} )

CRATES="
	aho-corasick@0.7.20
	atty@0.2.14
	autocfg@1.1.0
	base64@0.13.1
	bitflags@1.3.2
	bitflags@2.4.1
	bumpalo@3.11.1
	byteorder@1.4.3
	bytes@1.3.0
	cc@1.0.77
	cfg-if@1.0.0
	core-foundation@0.9.3
	core-foundation-sys@0.8.3
	cpython@0.7.1
	crossbeam-channel@0.5.6
	crossbeam-deque@0.8.2
	crossbeam-epoch@0.9.13
	crossbeam-utils@0.8.14
	ed25519@1.5.2
	either@1.8.0
	encoding_rs@0.8.31
	env_logger@0.7.1
	equivalent@1.0.1
	errno@0.3.8
	etebase@0.5.3
	fastrand@1.8.0
	fixedbitset@0.4.2
	flapigen@0.6.0
	fnv@1.0.7
	foreign-types@0.3.2
	foreign-types-shared@0.1.1
	form_urlencoded@1.1.0
	futures-channel@0.3.25
	futures-core@0.3.25
	futures-io@0.3.25
	futures-sink@0.3.25
	futures-task@0.3.25
	futures-util@0.3.25
	h2@0.3.17
	hashbrown@0.12.3
	hashbrown@0.14.3
	heck@0.4.1
	hermit-abi@0.1.19
	home@0.5.9
	http@0.2.8
	http-body@0.4.5
	httparse@1.8.0
	httpdate@1.0.2
	humantime@1.3.0
	hyper@0.14.23
	hyper-tls@0.5.0
	idna@0.3.0
	indexmap@1.9.2
	indexmap@2.1.0
	instant@0.1.12
	ipnet@2.6.0
	itoa@1.0.4
	js-sys@0.3.60
	lazy_static@1.4.0
	libc@0.2.151
	libsodium-sys@0.2.7
	linux-raw-sys@0.4.12
	log@0.4.17
	memchr@2.5.0
	memoffset@0.7.1
	mime@0.3.16
	mio@0.8.5
	native-tls@0.2.11
	num-traits@0.2.15
	num_cpus@1.14.0
	once_cell@1.16.0
	openssl@0.10.55
	openssl-macros@0.1.0
	openssl-probe@0.1.5
	openssl-src@111.24.0+1.1.1s
	openssl-sys@0.9.90
	paste@1.0.9
	percent-encoding@2.2.0
	petgraph@0.6.4
	pin-project-lite@0.2.9
	pin-utils@0.1.0
	pkg-config@0.3.26
	proc-macro2@1.0.47
	python3-sys@0.7.1
	quick-error@1.2.3
	quote@1.0.21
	rayon@1.6.1
	rayon-core@1.10.1
	redox_syscall@0.2.16
	regex@1.7.0
	regex-syntax@0.6.28
	remove_dir_all@0.5.3
	remove_dir_all@0.6.1
	reqwest@0.11.13
	rmp@0.8.11
	rmp-serde@1.1.1
	rustc-hash@1.1.0
	rustix@0.38.28
	rustversion@1.0.14
	ryu@1.0.11
	same-file@1.0.6
	schannel@0.1.20
	scopeguard@1.1.0
	security-framework@2.7.0
	security-framework-sys@2.6.1
	serde@1.0.149
	serde_bytes@0.11.7
	serde_derive@1.0.149
	serde_json@1.0.89
	serde_repr@0.1.9
	serde_urlencoded@0.7.1
	signature@1.6.4
	slab@0.4.7
	smallvec@1.10.0
	smol_str@0.2.0
	socket2@0.4.7
	sodiumoxide@0.2.7
	strum@0.24.1
	strum_macros@0.24.3
	syn@1.0.105
	tempfile@3.3.0
	termcolor@1.1.3
	tinyvec@1.6.0
	tinyvec_macros@0.1.0
	tokio@1.24.1
	tokio-native-tls@0.3.0
	tokio-util@0.7.4
	tower-service@0.3.2
	tracing@0.1.37
	tracing-core@0.1.30
	try-lock@0.2.3
	unicode-bidi@0.3.8
	unicode-ident@1.0.5
	unicode-normalization@0.1.22
	url@2.3.1
	vcpkg@0.2.15
	walkdir@2.3.2
	want@0.3.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.83
	wasm-bindgen-backend@0.2.83
	wasm-bindgen-futures@0.4.33
	wasm-bindgen-macro@0.2.83
	wasm-bindgen-macro-support@0.2.83
	wasm-bindgen-shared@0.2.83
	web-sys@0.3.60
	which@4.4.2
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.36.1
	windows-sys@0.42.0
	windows-sys@0.52.0
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.42.0
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.36.1
	windows_aarch64_msvc@0.42.0
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.36.1
	windows_i686_gnu@0.42.0
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.36.1
	windows_i686_msvc@0.42.0
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.36.1
	windows_x86_64_gnu@0.42.0
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.42.0
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.36.1
	windows_x86_64_msvc@0.42.0
	windows_x86_64_msvc@0.52.0
	winreg@0.10.1
"

inherit cargo distutils-r1

DESCRIPTION="Etebase Python library"
HOMEPAGE="https://www.etesync.com https://github.com/etesync/etebase-py"
SRC_URI="https://github.com/etesync/etebase-py/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"

LICENSE="BSD
	|| ( Apache-2.0 MIT )
	Unicode-DFS-2016
	Apache-2.0
	|| ( Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT )
	|| ( Apache-2.0 Boost-1.0 )
	|| ( Apache-2.0 MIT ZLIB )
	MIT
	|| ( MIT Unlicense )
	PYTHON"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/openssl:=
	dev-python/msgpack[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
"

PATCHES=( "$FILESDIR"/${P}-flapigen.patch )

src_unpack() {
	cargo_src_unpack
}
