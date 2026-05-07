# Limitations

## Package Availability

Graphite upstream documents source, pip, and virtualenv installation. The default upstream layout still uses `/opt/graphite`, and pip/source installs require Python development headers plus Cairo and libffi development packages.

### APT (Debian/Ubuntu)

* Debian 12: `graphite-carbon` 1.1.7, `graphite-web` 1.1.8, and `python3-whisper` are available as architecture-independent packages through Debian bookworm.
* Ubuntu 22.04: `graphite-carbon` 1.1.7 is published for amd64, arm64, armhf, i386, ppc64el, riscv64, and s390x; `graphite-web` 1.1.8 is published as an `all` package.
* Ubuntu 24.04: `graphite-carbon` 1.1.7 is available in universe; Launchpad also records a proposed Python 3.12 compatibility patch. `graphite-web` remains available through Ubuntu package archives.

### DNF/YUM (RHEL family)

* Current Fedora package data only shows `graphite-web` and `python-carbon` releases for EPEL 7. No current EPEL 8, EPEL 9, or EPEL 10 package is advertised.
* Because EPEL 7 is EOL with CentOS 7, this cookbook no longer declares current RHEL-family package support.

### Zypper (SUSE)

* No current official Graphite package support was identified for openSUSE Leap in the researched upstream and distro package sources.

## Architecture Limitations

* Debian `graphite-carbon` and `graphite-web` packages are `all` packages.
* Ubuntu 22.04 publishes `graphite-carbon` for amd64, arm64, armhf, i386, ppc64el, riscv64, and s390x.
* Pip and source installs depend on the target platform's Python packaging and build toolchain rather than a vendor-supported binary matrix.

## Source/Compiled Installation

### Build Dependencies

| Platform Family | Packages |
|-----------------|----------|
| Debian | `python3-venv`, `python3-dev`, `libcairo2-dev`, `libffi-dev`, `build-essential`, `python3-rrdtool` |
| RHEL | `python3`, `python3-devel`, `cairo-devel`, `libffi-devel`, `gcc`, `make`, `rrdtool-python3` |

## Platform Support Rationale

* Ubuntu 18.04 and 20.04 are removed from tested support because they are outside standard support as of 7 May 2026.
* Debian 8, 9, 10, and 11 are removed because they are EOL as of 7 May 2026.
* CentOS and Scientific Linux are removed because the cookbook's prior RHEL-family package path depended on EOL distributions or unavailable current Graphite packages.

## Sources

* [Graphite installing from pip](https://graphite.readthedocs.io/en/stable/install-pip.html)
* [Graphite installation layout](https://graphite.readthedocs.io/en/latest/install.html)
* [Debian graphite-carbon package](https://packages.debian.org/bookworm/graphite-carbon)
* [Debian graphite-web package](https://packages.debian.org/bookworm/graphite-web)
* [Ubuntu Jammy graphite-carbon package](https://launchpad.net/ubuntu/jammy/+package/graphite-carbon)
* [Ubuntu Jammy graphite-web package](https://launchpad.net/ubuntu/jammy/+package/graphite-web)
* [Ubuntu Noble graphite-carbon package](https://launchpad.net/ubuntu/noble/+source/graphite-carbon)
* [Fedora graphite-web package](https://packages.fedoraproject.org/pkgs/graphite-web/graphite-web)
* [Fedora python-carbon package](https://packages.fedoraproject.org/pkgs/python-carbon/python-carbon)
* [Ubuntu lifecycle](https://endoflife.date/ubuntu)
* [Debian lifecycle](https://eol.wiki/debian/)
* [CentOS lifecycle](https://endoflife.date/centos)
