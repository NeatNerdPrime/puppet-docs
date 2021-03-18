---
layout: default
built_from_commit: 959c82533074efbcc06e5755def1ff829abd53fa
title: 'Resource Type: package'
canonical: "/puppet/latest/types/package.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2021-03-18 10:01:29 +0000

package
-----

* [Attributes](#package-attributes)
* [Providers](#package-providers)
* [Provider Features](#package-provider-features)

<h3 id="package-description">Description</h3>

Manage packages.  There is a basic dichotomy in package
support right now:  Some package types (such as yum and apt) can
retrieve their own package files, while others (such as rpm and sun)
cannot.  For those package formats that cannot retrieve their own files,
you can use the `source` parameter to point to the correct file.

Puppet will automatically guess the packaging format that you are
using based on the platform you are on, but you can override it
using the `provider` parameter; each provider defines what it
requires in order to function, and you must meet those requirements
to use a given provider.

You can declare multiple package resources with the same `name` as long
as they have unique titles, and specify different providers and commands.

Note that you must use the _title_ to make a reference to a package
resource; `Package[<NAME>]` is not a synonym for `Package[<TITLE>]` like
it is for many other resource types.

**Autorequires:** If Puppet is managing the files specified as a
package's `adminfile`, `responsefile`, or `source`, the package
resource will autorequire those files.

<h3 id="package-attributes">Attributes</h3>

<pre><code>package { 'resource title':
  <a href="#package-attribute-name">name</a>                 =&gt; <em># <strong>(namevar)</strong> The package name.  This is the name that the...</em>
  <a href="#package-attribute-command">command</a>              =&gt; <em># <strong>(namevar)</strong> The targeted command to use when managing a...</em>
  <a href="#package-attribute-ensure">ensure</a>               =&gt; <em># What state the package should be in. On...</em>
  <a href="#package-attribute-adminfile">adminfile</a>            =&gt; <em># A file containing package defaults for...</em>
  <a href="#package-attribute-allow_virtual">allow_virtual</a>        =&gt; <em># Specifies if virtual package names are allowed...</em>
  <a href="#package-attribute-allowcdrom">allowcdrom</a>           =&gt; <em># Tells apt to allow cdrom sources in the...</em>
  <a href="#package-attribute-category">category</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-configfiles">configfiles</a>          =&gt; <em># Whether to keep or replace modified config files </em>
  <a href="#package-attribute-description">description</a>          =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-enable_only">enable_only</a>          =&gt; <em># Tells `dnf module` to only enable a specific...</em>
  <a href="#package-attribute-flavor">flavor</a>               =&gt; <em># OpenBSD and DNF modules support 'flavors', which </em>
  <a href="#package-attribute-install_only">install_only</a>         =&gt; <em># It should be set for packages that should only...</em>
  <a href="#package-attribute-install_options">install_options</a>      =&gt; <em># An array of additional options to pass when...</em>
  <a href="#package-attribute-instance">instance</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-mark">mark</a>                 =&gt; <em># Set to hold to tell Debian apt/Solaris pkg to...</em>
  <a href="#package-attribute-package_settings">package_settings</a>     =&gt; <em># Settings that can change the contents or...</em>
  <a href="#package-attribute-platform">platform</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-provider">provider</a>             =&gt; <em># The specific backend to use for this `package...</em>
  <a href="#package-attribute-reinstall_on_refresh">reinstall_on_refresh</a> =&gt; <em># Whether this resource should respond to refresh...</em>
  <a href="#package-attribute-responsefile">responsefile</a>         =&gt; <em># A file containing any necessary answers to...</em>
  <a href="#package-attribute-root">root</a>                 =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-source">source</a>               =&gt; <em># Where to find the package file. This is mostly...</em>
  <a href="#package-attribute-status">status</a>               =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-uninstall_options">uninstall_options</a>    =&gt; <em># An array of additional options to pass when...</em>
  <a href="#package-attribute-vendor">vendor</a>               =&gt; <em># A read-only parameter set by the...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="package-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The package name.  This is the name that the packaging
system uses internally, which is sometimes (especially on Solaris)
a name that is basically useless to humans.  If a package goes by
several names, you can use a single title and then set the name
conditionally:

    # In the 'openssl' class
    $ssl = $operatingsystem ? {
      solaris => SMCossl,
      default => openssl
    }

    package { 'openssl':
      ensure => installed,
      name   => $ssl,
    }

    ...

    $ssh = $operatingsystem ? {
      solaris => SMCossh,
      default => openssh
    }

    package { 'openssh':
      ensure  => installed,
      name    => $ssh,
      require => Package['openssl'],
    }

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-command">command</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The targeted command to use when managing a package:

  package { 'mysql':
    provider => gem,
  }

  package { 'mysql-opt':
    name     => 'mysql',
    provider => gem,
    command  => '/opt/ruby/bin/gem',
  }

Each provider defines a package management command; and uses the first
instance of the command found in the PATH.

Providers supporting the targetable feature allow you to specify the
absolute path of the package management command; useful when multiple
instances of the command are installed, or the command is not in the PATH.

Default: `default`

Requires features targetable.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What state the package should be in. On packaging systems that can
retrieve new packages on their own, you can choose which package to
retrieve by specifying a version number or `latest` as the ensure
value. On packaging systems that manage configuration files separately
from "normal" system files, you can uninstall config files by
specifying `purged` as the ensure value. This defaults to `installed`.

Version numbers must match the full version to install, including
release if the provider uses a release moniker. For
example, to install the bash package from the rpm
`bash-4.1.2-29.el6.x86_64.rpm`, use the string `'4.1.2-29.el6'`.

On supported providers, version ranges can also be ensured. For example,
inequalities: `<2.0.0`, or intersections: `>1.0.0 <2.0.0`.

Default: `installed`

Allowed values:

* `present`
* `absent`
* `purged`
* `disabled`
* `installed`
* `latest`
* `/./`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-adminfile">adminfile</h4>

A file containing package defaults for installing packages.

This attribute is only used on Solaris. Its value should be a path to a
local file stored on the target system. Solaris's package tools expect
either an absolute file path or a relative path to a file in
`/var/sadm/install/admin`.

The value of `adminfile` will be passed directly to the `pkgadd` or
`pkgrm` command with the `-a <ADMINFILE>` option.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-allow_virtual">allow_virtual</h4>

Specifies if virtual package names are allowed for install and uninstall.

Allowed values:

* `true`
* `false`
* `yes`
* `no`

Requires features virtual_packages.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-allowcdrom">allowcdrom</h4>

Tells apt to allow cdrom sources in the sources.list file.
Normally apt will bail if you try this.

Allowed values:

* `true`
* `false`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-category">category</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-configfiles">configfiles</h4>

Whether to keep or replace modified config files when installing or
upgrading a package. This only affects the `apt` and `dpkg` providers.

Default: `keep`

Allowed values:

* `keep`
* `replace`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-description">description</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-enable_only">enable_only</h4>

Tells `dnf module` to only enable a specific module, instead
of installing its default profile.

Modules with no default profile will be enabled automatically
without the use of this parameter.

Conflicts with the `flavor` property, which selects a profile
to install.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-flavor">flavor</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

OpenBSD and DNF modules support 'flavors', which are
further specifications for which type of package you want.

Requires features supports_flavors.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-install_only">install_only</h4>

It should be set for packages that should only ever be installed,
never updated. Kernels in particular fall into this category.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

Requires features install_only.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-install_options">install_options</h4>

An array of additional options to pass when installing a package. These
options are package-specific, and should be documented by the software
vendor.  One commonly implemented option is `INSTALLDIR`:

    package { 'mysql':
      ensure          => installed,
      source          => 'N:/packages/mysql-5.5.16-winx64.msi',
      install_options => [ '/S', { 'INSTALLDIR' => 'C:\\mysql-5.5' } ],
    }

Each option in the array can either be a string or a hash, where each
key and value pair are interpreted in a provider specific way.  Each
option will automatically be quoted when passed to the install command.

With Windows packages, note that file paths in an install option must
use backslashes. (Since install options are passed directly to the
installation command, forward slashes won't be automatically converted
like they are in `file` resources.) Note also that backslashes in
double-quoted strings _must_ be escaped and backslashes in single-quoted
strings _can_ be escaped.

Requires features install_options.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-instance">instance</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-mark">mark</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Set to hold to tell Debian apt/Solaris pkg to hold the package version

#{mark_doc}
Default is "none". Mark can be specified with or without `ensure`,
if `ensure` is missing will default to "present".

Mark cannot be specified together with "purged", or "absent"
values for `ensure`.

Allowed values:

* `hold`
* `none`

Requires features holdable.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-package_settings">package_settings</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Settings that can change the contents or configuration of a package.

The formatting and effects of package_settings are provider-specific; any
provider that implements them must explain how to use them in its
documentation. (Our general expectation is that if a package is
installed but its settings are out of sync, the provider should
re-install that package with the desired settings.)

An example of how package_settings could be used is FreeBSD's port build
options --- a future version of the provider could accept a hash of options,
and would reinstall the port if the installed version lacked the correct
settings.

    package { 'www/apache22':
      package_settings => { 'SUEXEC' => false }
    }

Again, check the documentation of your platform's package provider to see
the actual usage.

Requires features package_settings.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-platform">platform</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-provider">provider</h4>

The specific backend to use for this `package` resource. You will seldom need to specify this --- Puppet will usually discover the appropriate provider for your platform.

Available providers are:

* [`aix`](#package-provider-aix)
* [`appdmg`](#package-provider-appdmg)
* [`apple`](#package-provider-apple)
* [`apt`](#package-provider-apt)
* [`aptitude`](#package-provider-aptitude)
* [`aptrpm`](#package-provider-aptrpm)
* [`blastwave`](#package-provider-blastwave)
* [`dnf`](#package-provider-dnf)
* [`dnfmodule`](#package-provider-dnfmodule)
* [`dpkg`](#package-provider-dpkg)
* [`fink`](#package-provider-fink)
* [`freebsd`](#package-provider-freebsd)
* [`gem`](#package-provider-gem)
* [`hpux`](#package-provider-hpux)
* [`macports`](#package-provider-macports)
* [`nim`](#package-provider-nim)
* [`openbsd`](#package-provider-openbsd)
* [`opkg`](#package-provider-opkg)
* [`pacman`](#package-provider-pacman)
* [`pip2`](#package-provider-pip2)
* [`pip3`](#package-provider-pip3)
* [`pip`](#package-provider-pip)
* [`pkg`](#package-provider-pkg)
* [`pkgdmg`](#package-provider-pkgdmg)
* [`pkgin`](#package-provider-pkgin)
* [`pkgng`](#package-provider-pkgng)
* [`pkgutil`](#package-provider-pkgutil)
* [`portage`](#package-provider-portage)
* [`ports`](#package-provider-ports)
* [`portupgrade`](#package-provider-portupgrade)
* [`puppet_gem`](#package-provider-puppet_gem)
* [`puppetserver_gem`](#package-provider-puppetserver_gem)
* [`rpm`](#package-provider-rpm)
* [`rug`](#package-provider-rug)
* [`sun`](#package-provider-sun)
* [`sunfreeware`](#package-provider-sunfreeware)
* [`tdnf`](#package-provider-tdnf)
* [`up2date`](#package-provider-up2date)
* [`urpmi`](#package-provider-urpmi)
* [`windows`](#package-provider-windows)
* [`yum`](#package-provider-yum)
* [`zypper`](#package-provider-zypper)

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-reinstall_on_refresh">reinstall_on_refresh</h4>

Whether this resource should respond to refresh events (via `subscribe`,
`notify`, or the `~>` arrow) by reinstalling the package. Only works for
providers that support the `reinstallable` feature.

This is useful for source-based distributions, where you may want to
recompile a package if the build options change.

If you use this, be careful of notifying classes when you want to restart
services. If the class also contains a refreshable package, doing so could
cause unnecessary re-installs.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-responsefile">responsefile</h4>

A file containing any necessary answers to questions asked by
the package.  This is currently used on Solaris and Debian.  The
value will be validated according to system rules, but it should
generally be a fully qualified path.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-root">root</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-source">source</h4>

Where to find the package file. This is mostly used by providers that don't
automatically download packages from a central repository. (For example:
the `yum` provider ignores this attribute, `apt` provider uses it if present
and the `rpm` and `dpkg` providers require it.)

Different providers accept different values for `source`. Most providers
accept paths to local files stored on the target system. Some providers
may also accept URLs or network drive paths. Puppet will not
automatically retrieve source files for you, and usually just passes the
value of `source` to the package installation command.

You can use a `file` resource if you need to manually copy package files
to the target system.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-status">status</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-uninstall_options">uninstall_options</h4>

An array of additional options to pass when uninstalling a package. These
options are package-specific, and should be documented by the software
vendor.  For example:

    package { 'VMware Tools':
      ensure            => absent,
      uninstall_options => [ { 'REMOVE' => 'Sync,VSS' } ],
    }

Each option in the array can either be a string or a hash, where each
key and value pair are interpreted in a provider specific way.  Each
option will automatically be quoted when passed to the uninstall
command.

On Windows, this is the **only** place in Puppet where backslash
separators should be used.  Note that backslashes in double-quoted
strings _must_ be double-escaped and backslashes in single-quoted
strings _may_ be double-escaped.

Requires features uninstall_options.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-vendor">vendor</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))


<h3 id="package-providers">Providers</h3>

<h4 id="package-provider-aix">aix</h4>

Installation from an AIX software directory, using the AIX `installp`
command.  The `source` parameter is required for this provider, and should
be set to the absolute path (on the puppet agent machine) of a directory
containing one or more BFF package files.

The `installp` command will generate a table of contents file (named `.toc`)
in this directory, and the `name` parameter (or resource title) that you
specify for your `package` resource must match a package name that exists
in the `.toc` file.

Note that package downgrades are *not* supported; if your resource specifies
a specific version number and there is already a newer version of the package
installed on the machine, the resource will fail with an error message.

* Required binaries: `/usr/bin/lslpp`, `/usr/sbin/installp`
* Confined to: `operatingsystem == [ :aix ]`
* Default for: `["operatingsystem", "aix"] == `
* Supported features: `versionable`

<h4 id="package-provider-appdmg">appdmg</h4>

Package management which copies application bundles to a target.

* Required binaries: `/usr/bin/hdiutil`, `/usr/bin/curl`, `/usr/bin/ditto`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`

<h4 id="package-provider-apple">apple</h4>

Package management based on OS X's built-in packaging system.  This is
essentially the simplest and least functional package system in existence --
it only supports installation; no deletion or upgrades.  The provider will
automatically add the `.pkg` extension, so leave that off when specifying
the package name.

* Required binaries: `/usr/sbin/installer`
* Confined to: `operatingsystem == darwin`

<h4 id="package-provider-apt">apt</h4>

Package management via `apt-get`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to apt-get.
These options should be specified as an array where each element is either a
 string or a hash.

* Required binaries: `/usr/bin/apt-get`, `/usr/bin/apt-cache`, `/usr/bin/apt-mark`, `/usr/bin/debconf-set-selections`
* Default for: `["osfamily", "debian"] == `
* Supported features: `versionable`, `install_options`, `virtual_packages`

<h4 id="package-provider-aptitude">aptitude</h4>

Package management via `aptitude`.

* Required binaries: `/usr/bin/aptitude`, `/usr/bin/apt-cache`
* Supported features: `versionable`

<h4 id="package-provider-aptrpm">aptrpm</h4>

Package management via `apt-get` ported to `rpm`.

* Required binaries: `apt-get`, `apt-cache`, `rpm`
* Supported features: `versionable`

<h4 id="package-provider-blastwave">blastwave</h4>

Package management using Blastwave.org's `pkg-get` command on Solaris.

* Required binaries: `pkgget`
* Confined to: `osfamily == solaris`

<h4 id="package-provider-dnf">dnf</h4>

Support via `dnf`.

Using this provider's `uninstallable` feature will not remove dependent packages. To
remove dependent packages with this provider use the `purgeable` feature, but note this
feature is destructive and should be used with the utmost care.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to dnf.
These options should be specified as an array where each element is either
 a string or a hash.

* Required binaries: `dnf`, `rpm`
* Default for: `["operatingsystem", "fedora"] == `, `["osfamily", "redhat"] == `
* Supported features: `install_options`, `versionable`, `virtual_packages`, `install_only`

<h4 id="package-provider-dnfmodule">dnfmodule</h4>



* Required binaries: `/usr/bin/dnf`
* Supported features: `installable`, `uninstallable`, `versionable`, `supports_flavors`, `disableable`

<h4 id="package-provider-dpkg">dpkg</h4>

Package management via `dpkg`.  Because this only uses `dpkg`
and not `apt`, you must specify the source of any packages you want
to manage.

* Required binaries: `/usr/bin/dpkg`, `/usr/bin/dpkg-deb`, `/usr/bin/dpkg-query`
* Supported features: `holdable`, `virtual_packages`

<h4 id="package-provider-fink">fink</h4>

Package management via `fink`.

* Required binaries: `/sw/bin/fink`, `/sw/bin/apt-get`, `/sw/bin/apt-cache`, `/sw/bin/dpkg-query`
* Supported features: `versionable`

<h4 id="package-provider-freebsd">freebsd</h4>

The specific form of package management on FreeBSD.  This is an
extremely quirky packaging system, in that it freely mixes between
ports and packages.  Apparently all of the tools are written in Ruby,
so there are plans to rewrite this support to directly use those
libraries.

* Required binaries: `/usr/sbin/pkg_info`, `/usr/sbin/pkg_add`, `/usr/sbin/pkg_delete`
* Confined to: `operatingsystem == freebsd`

<h4 id="package-provider-gem">gem</h4>

Ruby Gem support. If a URL is passed via `source`, then that URL is
appended to the list of remote gem repositories; to ensure that only the
specified source is used, also pass `--clear-sources` via `install_options`.
If source is present but is not a valid URL, it will be interpreted as the
path to a local gem file. If source is not present, the gem will be
installed from the default gem repositories. Note that to modify this for Windows, it has to be a valid URL.

This provider supports the `install_options` and `uninstall_options` attributes,
which allow command-line flags to be passed to the gem command.
These options should be specified as an array where each element is either a
string or a hash.
* Supported features: `versionable`, `install_options`, `uninstall_options`, `targetable`, `version_ranges`

<h4 id="package-provider-hpux">hpux</h4>

HP-UX's packaging system.

* Required binaries: `/usr/sbin/swinstall`, `/usr/sbin/swlist`, `/usr/sbin/swremove`
* Confined to: `operatingsystem == hp-ux`
* Default for: `["operatingsystem", "hp-ux"] == `

<h4 id="package-provider-macports">macports</h4>

Package management using MacPorts on OS X.

Supports MacPorts versions and revisions, but not variants.
Variant preferences may be specified using
[the MacPorts variants.conf file](http://guide.macports.org/chunked/internals.configuration-files.html#internals.configuration-files.variants-conf).

When specifying a version in the Puppet DSL, only specify the version, not the revision.
Revisions are only used internally for ensuring the latest version/revision of a port.

* Confined to: `operatingsystem == darwin`
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-nim">nim</h4>

Installation from an AIX NIM LPP source.  The `source` parameter is required
for this provider, and should specify the name of a NIM `lpp_source` resource
that is visible to the puppet agent machine.  This provider supports the
management of both BFF/installp and RPM packages.

Note that package downgrades are *not* supported; if your resource specifies
a specific version number and there is already a newer version of the package
installed on the machine, the resource will fail with an error message.

* Required binaries: `/usr/sbin/nimclient`, `/usr/bin/lslpp`, `rpm`
* Confined to: `exists == /etc/niminfo`
* Supported features: `versionable`

<h4 id="package-provider-openbsd">openbsd</h4>

OpenBSD's form of `pkg_add` support.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to pkg_add and pkg_delete.
These options should be specified as an array where each element is either a
 string or a hash.

* Required binaries: `pkg_info`, `pkg_add`, `pkg_delete`
* Confined to: `operatingsystem == openbsd`
* Default for: `["operatingsystem", "openbsd"] == `
* Supported features: `versionable`, `install_options`, `uninstall_options`, `upgradeable`, `supports_flavors`

<h4 id="package-provider-opkg">opkg</h4>

Opkg packaging support. Common on OpenWrt and OpenEmbedded platforms

* Required binaries: `opkg`
* Confined to: `operatingsystem == openwrt`
* Default for: `["operatingsystem", "openwrt"] == `

<h4 id="package-provider-pacman">pacman</h4>

Support for the Package Manager Utility (pacman) used in Archlinux.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pacman.
These options should be specified as an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/pacman`
* Confined to: `operatingsystem == [:archlinux, :manjarolinux]`
* Default for: `["operatingsystem", "[:archlinux, :manjarolinux]"] == `
* Supported features: `install_options`, `uninstall_options`, `upgradeable`, `virtual_packages`

<h4 id="package-provider-pip">pip</h4>

Python packages via `pip`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip.
These options should be specified as an array where each element is either a string or a hash.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`, `version_ranges`, `install_options`, `targetable`

<h4 id="package-provider-pip2">pip2</h4>

Python packages via `pip2`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip2.
These options should be specified as an array where each element is either a string or a hash.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`, `install_options`, `targetable`

<h4 id="package-provider-pip3">pip3</h4>

Python packages via `pip3`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip3.
These options should be specified as an array where each element is either a string or a hash.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`, `install_options`, `targetable`

<h4 id="package-provider-pkg">pkg</h4>

OpenSolaris image packaging system. See pkg(5) for more information.

This provider supports the `install_options` attribute, which allows
command-line flags to be passed to pkg. These options should be specified as an
array where each element is either a string or a hash.

* Required binaries: `/usr/bin/pkg`
* Confined to: `osfamily == solaris`
* Default for: `["osfamily", "solaris"] == ["kernelrelease", "['5.11', '5.12']"]`
* Supported features: `versionable`, `upgradable`, `holdable`, `install_options`

<h4 id="package-provider-pkgdmg">pkgdmg</h4>

Package management based on Apple's Installer.app and DiskUtility.app.

This provider works by checking the contents of a DMG image for Apple pkg or
mpkg files. Any number of pkg or mpkg files may exist in the root directory
of the DMG file system, and Puppet will install all of them. Subdirectories
are not checked for packages.

This provider can also accept plain .pkg (but not .mpkg) files in addition
to .dmg files.

Notes:

* The `source` attribute is mandatory. It must be either a local disk path
  or an HTTP, HTTPS, or FTP URL to the package.
* The `name` of the resource must be the filename (without path) of the DMG file.
* When installing the packages from a DMG, this provider writes a file to
  disk at `/var/db/.puppet_pkgdmg_installed_NAME`. If that file is present,
  Puppet assumes all packages from that DMG are already installed.
* This provider is not versionable and uses DMG filenames to determine
  whether a package has been installed. Thus, to install new a version of a
  package, you must create a new DMG with a different filename.

* Required binaries: `/usr/sbin/installer`, `/usr/bin/hdiutil`, `/usr/bin/curl`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Default for: `["operatingsystem", "darwin"] == `

<h4 id="package-provider-pkgin">pkgin</h4>

Package management using pkgin, a binary package manager for pkgsrc.

* Required binaries: `pkgin`
* Default for: `["operatingsystem", "[ :smartos, :netbsd ]"] == `
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-pkgng">pkgng</h4>

A PkgNG provider for FreeBSD and DragonFly.

* Required binaries: `/usr/local/sbin/pkg`
* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for: `["operatingsystem", "[:freebsd, :dragonfly]"] == `
* Supported features: `versionable`, `upgradeable`, `install_options`

<h4 id="package-provider-pkgutil">pkgutil</h4>

Package management using Peter Bonivart's ``pkgutil`` command on Solaris.

* Confined to: `osfamily == solaris`

<h4 id="package-provider-portage">portage</h4>

Provides packaging support for Gentoo's portage system.

This provider supports the `install_options` and `uninstall_options` attributes, which allows command-line
flags to be passed to emerge. These options should be specified as an array where each element is either a string or a hash.

* Confined to: `osfamily == gentoo`
* Default for: `["osfamily", "gentoo"] == `
* Supported features: `install_options`, `purgeable`, `reinstallable`, `uninstall_options`, `versionable`, `virtual_packages`

<h4 id="package-provider-ports">ports</h4>

Support for FreeBSD's ports.  Note that this, too, mixes packages and ports.

* Required binaries: `/usr/local/sbin/portupgrade`, `/usr/local/sbin/portversion`, `/usr/local/sbin/pkg_deinstall`, `/usr/sbin/pkg_info`

<h4 id="package-provider-portupgrade">portupgrade</h4>

Support for FreeBSD's ports using the portupgrade ports management software.
Use the port's full origin as the resource name. eg (ports-mgmt/portupgrade)
for the portupgrade port.

* Required binaries: `/usr/local/sbin/portupgrade`, `/usr/local/sbin/portinstall`, `/usr/local/sbin/portversion`, `/usr/local/sbin/pkg_deinstall`, `/usr/sbin/pkg_info`

<h4 id="package-provider-puppet_gem">puppet_gem</h4>

Puppet Ruby Gem support. This provider is useful for managing
gems needed by the ruby provided in the puppet-agent package.
* Supported features: `versionable`, `install_options`, `uninstall_options`

<h4 id="package-provider-puppetserver_gem">puppetserver_gem</h4>

Puppet Server Ruby Gem support. If a URL is passed via `source`, then
that URL is appended to the list of remote gem repositories which by default
contains rubygems.org; To ensure that only the specified source is used also
pass `--clear-sources` in via `install_options`; if a source is present but
is not a valid URL, it will be interpreted as the path to a local gem file.
If source is not present at all, the gem will be installed from the default
gem repositories.

* Confined to: `feature == hocon`, `fips_enabled == false`
* Supported features: `versionable`, `install_options`, `uninstall_options`

<h4 id="package-provider-rpm">rpm</h4>

RPM packaging support; should work anywhere with a working `rpm`
binary.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to rpm.
These options should be specified as an array where each element is either a string or a hash.

* Required binaries: `rpm`
* Supported features: `versionable`, `install_options`, `uninstall_options`, `virtual_packages`, `install_only`

<h4 id="package-provider-rug">rug</h4>

Support for suse `rug` package manager.

* Required binaries: `/usr/bin/rug`, `rpm`
* Confined to: `operatingsystem == [:suse, :sles]`
* Supported features: `versionable`

<h4 id="package-provider-sun">sun</h4>

Sun's packaging system.  Requires that you specify the source for
the packages you're managing.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pkgadd.
These options should be specified as an array where each element is either a string
 or a hash.

* Required binaries: `/usr/bin/pkginfo`, `/usr/sbin/pkgadd`, `/usr/sbin/pkgrm`
* Confined to: `osfamily == solaris`
* Default for: `["osfamily", "solaris"] == `
* Supported features: `install_options`

<h4 id="package-provider-sunfreeware">sunfreeware</h4>

Package management using sunfreeware.com's `pkg-get` command on Solaris.
At this point, support is exactly the same as `blastwave` support and
has not actually been tested.

* Required binaries: `pkg-get`
* Confined to: `osfamily == solaris`

<h4 id="package-provider-tdnf">tdnf</h4>

Support via `tdnf`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to tdnf.
These options should be spcified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}), or an
array where each element is either a string or a hash.

* Required binaries: `tdnf`, `rpm`
* Default for: `["operatingsystem", "PhotonOS"] == `
* Supported features: `install_options`, `versionable`, `virtual_packages`

<h4 id="package-provider-up2date">up2date</h4>

Support for Red Hat's proprietary `up2date` package update
mechanism.

* Required binaries: `/usr/sbin/up2date-nox`
* Confined to: `osfamily == redhat`
* Default for: `["osfamily", "redhat"] == ["lsbdistrelease", "[\"2.1\", \"3\", \"4\"]"]`

<h4 id="package-provider-urpmi">urpmi</h4>

Support via `urpmi`.

* Required binaries: `urpmi`, `urpmq`, `rpm`, `urpme`
* Default for: `["operatingsystem", "[:mandriva, :mandrake]"] == `
* Supported features: `versionable`

<h4 id="package-provider-windows">windows</h4>

Windows package management.

This provider supports either MSI or self-extracting executable installers.

This provider requires a `source` attribute when installing the package.
It accepts paths to local files, mapped drives, or UNC paths.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to the installer.
These options should be specified as an array where each element is either
a string or a hash.

If the executable requires special arguments to perform a silent install or
uninstall, then the appropriate arguments should be specified using the
`install_options` or `uninstall_options` attributes, respectively.  Puppet
will automatically quote any option that contains spaces.

* Confined to: `operatingsystem == windows`
* Default for: `["operatingsystem", "windows"] == `
* Supported features: `installable`, `uninstallable`, `install_options`, `uninstall_options`, `versionable`

<h4 id="package-provider-yum">yum</h4>

Support via `yum`.

Using this provider's `uninstallable` feature will not remove dependent packages. To
remove dependent packages with this provider use the `purgeable` feature, but note this
feature is destructive and should be used with the utmost care.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to yum.
These options should be specified as an array where each element is either a string or a hash.

* Required binaries: `yum`, `rpm`
* Default for: `["operatingsystem", "amazon"] == `, `["osfamily", "redhat"] == ["operatingsystemmajrelease", "(4..7).to_a"]`
* Supported features: `install_options`, `versionable`, `virtual_packages`, `install_only`

<h4 id="package-provider-zypper">zypper</h4>

Support for SuSE `zypper` package manager. Found in SLES10sp2+ and SLES11.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to zypper.
These options should be specified as an array where each element is either a
string or a hash.

* Required binaries: `/usr/bin/zypper`
* Confined to: `operatingsystem == [:suse, :sles, :sled, :opensuse]`
* Default for: `["operatingsystem", "[:suse, :sles, :sled, :opensuse]"] == `
* Supported features: `versionable`, `install_options`, `virtual_packages`

<h3 id="package-provider-features">Provider Features</h3>

Available features:

* `disableable` --- The provider can disable packages. This feature is used by specifying `disabled` as the desired value for the package.
* `holdable` --- The provider is capable of placing packages on hold such that they are not automatically upgraded as a result of other package dependencies unless explicit action is taken by a user or another package.
* `install_only` --- The provider accepts options to only install packages never update (kernels, etc.)
* `install_options` --- The provider accepts options to be passed to the installer command.
* `installable` --- The provider can install packages.
* `package_settings` --- The provider accepts package_settings to be ensured for the given package. The meaning and format of these settings is provider-specific.
* `purgeable` --- The provider can purge packages.  This generally means that all traces of the package are removed, including existing configuration files.  This feature is thus destructive and should be used with the utmost care.
* `reinstallable` --- The provider can reinstall packages.
* `supports_flavors` --- The provider accepts flavors, which are specific variants of packages.
* `targetable` --- The provider accepts a targeted package management command.
* `uninstall_options` --- The provider accepts options to be passed to the uninstaller command.
* `uninstallable` --- The provider can uninstall packages.
* `upgradeable` --- The provider can upgrade to the latest version of a package.  This feature is used by specifying `latest` as the desired value for the package.
* `version_ranges` --- The provider can ensure version ranges.
* `versionable` --- The provider is capable of interrogating the package database for installed version(s), and can select which out of a set of available versions of a package to install if asked.
* `virtual_packages` --- The provider accepts virtual package names for install and uninstall.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>disableable</th>
      <th>holdable</th>
      <th>install only</th>
      <th>install options</th>
      <th>installable</th>
      <th>package settings</th>
      <th>purgeable</th>
      <th>reinstallable</th>
      <th>supports flavors</th>
      <th>targetable</th>
      <th>uninstall options</th>
      <th>uninstallable</th>
      <th>upgradeable</th>
      <th>version ranges</th>
      <th>versionable</th>
      <th>virtual packages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>aix</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>appdmg</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>apple</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>apt</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>aptitude</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>aptrpm</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>blastwave</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>dnf</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>dnfmodule</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>dpkg</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>fink</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>freebsd</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>gem</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>hpux</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>macports</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>nim</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>openbsd</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>opkg</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pacman</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>pip</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pip2</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pip3</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkg</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgdmg</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgin</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgng</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgutil</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>portage</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>ports</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>portupgrade</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>puppet_gem</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>puppetserver_gem</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>rpm</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>rug</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>sun</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>sunfreeware</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>tdnf</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>up2date</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>urpmi</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>windows</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>yum</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>zypper</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>


> **NOTE:** This page was generated from the Puppet source code on 2021-02-10 10:04:33 +0000