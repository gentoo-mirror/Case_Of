# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.11.0
atty-0.2.14
autocfg-1.0.0
base64-0.12.3
bitflags-1.2.1
bumpalo-3.4.0
byteorder-1.3.4
bytes-0.5.6
cbindgen-0.14.4
cc-1.0.58
cfg-if-0.1.10
clap-2.33.3
core-foundation-0.7.0
core-foundation-sys-0.7.0
crossbeam-channel-0.4.4
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-utils-0.7.2
dtoa-0.4.6
either-1.6.1
encoding_rs-0.8.23
etebase-0.5.0
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-channel-0.3.5
futures-core-0.3.5
futures-io-0.3.5
futures-sink-0.3.5
futures-task-0.3.5
futures-util-0.3.5
getrandom-0.1.14
h2-0.2.6
hashbrown-0.8.1
heck-0.3.1
hermit-abi-0.1.15
http-0.2.1
http-body-0.3.1
httparse-1.3.4
hyper-0.13.7
hyper-tls-0.4.3
idna-0.2.0
indexmap-1.5.0
iovec-0.1.4
ipnet-2.3.0
itoa-0.4.6
js-sys-0.3.42
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.73
libsodium-sys-0.2.6
log-0.4.11
matches-0.1.8
maybe-uninit-2.0.0
memchr-2.3.3
memoffset-0.5.6
mime-0.3.16
mime_guess-2.0.3
mio-0.6.22
miow-0.2.1
native-tls-0.2.4
net2-0.2.34
num-traits-0.2.12
num_cpus-1.13.0
once_cell-1.4.0
openssl-0.10.30
openssl-probe-0.1.2
openssl-sys-0.9.62
percent-encoding-2.1.0
pin-project-0.4.23
pin-project-internal-0.4.23
pin-project-lite-0.1.7
pin-utils-0.1.0
pkg-config-0.3.18
ppv-lite86-0.2.8
proc-macro2-1.0.19
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
rayon-1.4.1
rayon-core-1.8.1
redox_syscall-0.1.57
remove_dir_all-0.5.3
remove_dir_all-0.6.0
reqwest-0.10.7
rmp-0.8.9
rmp-serde-0.14.4
ryu-1.0.5
schannel-0.1.19
scopeguard-1.1.0
security-framework-0.4.4
security-framework-sys-0.4.3
serde-1.0.114
serde_bytes-0.11.5
serde_derive-1.0.114
serde_json-1.0.57
serde_repr-0.1.6
serde_urlencoded-0.6.1
slab-0.4.2
socket2-0.3.12
sodiumoxide-0.2.6
strsim-0.8.0
syn-1.0.36
tempfile-3.1.0
textwrap-0.11.0
time-0.1.43
tinyvec-0.3.3
tokio-0.2.22
tokio-tls-0.3.1
tokio-util-0.3.1
toml-0.5.6
tower-service-0.3.0
tracing-0.1.17
tracing-core-0.1.11
try-lock-0.2.3
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.13
unicode-segmentation-1.6.0
unicode-width-0.1.8
unicode-xid-0.2.1
url-2.1.1
vcpkg-0.2.10
vec_map-0.8.2
version_check-0.9.2
want-0.3.0
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.65
wasm-bindgen-backend-0.2.65
wasm-bindgen-futures-0.4.15
wasm-bindgen-macro-0.2.65
wasm-bindgen-macro-support-0.2.65
wasm-bindgen-shared-0.2.65
web-sys-0.3.42
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.7.0
ws2_32-sys-0.2.1
"

inherit cargo

DESCRIPTION="C library for etebase"
HOMEPAGE="https://github.com/etesync/libetebase"
SRC_URI="
	https://github.com/etesync/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"
RESTRICT="mirror"
LICENSE="Apache-2.0
	|| ( Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT )
	|| ( Apache-2.0 Boost-1.0 )
	|| ( Apache-2.0 MIT )
	BSD
	MIT
	|| ( MIT Unlicense )
	MPL-2.0
	ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-cargo-dependency.patch" )

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
