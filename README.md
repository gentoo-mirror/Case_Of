# Case_Of Gentoo overlay

This overlay is primarily maintained for my personal own usage. Suggestions are welcome.

All packages in my overlay are usable but not enough tested to be considered stable. Keywords have to be set in `/etc/portage/package.accept_keywords` if your system is globally set on a stable keyword.

## Install this overlay in your system

### Using `app-eselect/eselect-repository`

```
eselect repository add Case_Of git https://framagit.org/Case_Of/gentoo-overlay.git
```

### Installing in `/etc/portage/repos.conf/Case_Of.conf`

```
[Case_Of]
# Set the priority you wish to use
priority = 1000
location = /path/to/Case_Of-overlay
sync-type = git
sync-uri = https://framagit.org/Case_Of/gentoo-overlay.git
```

## Signature

This overlay commits are signed with the PGP key `0xE88F5161FA7EB6A9EED232A76D8A6C9787A1EC91` that I also use in Gentoo's official portage tree contributions.
