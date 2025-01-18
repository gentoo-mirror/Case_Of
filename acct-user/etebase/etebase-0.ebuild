# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A group for net-misc/etebase-server"

ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( "etebase" )
ACCT_USER_HOME="/var/lib/etebase"
