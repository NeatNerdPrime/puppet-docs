---
layout: default
title: "Puppet system requirements"
---

Puppet's system requirements can depend on your deployment type and size. Before installing, ensure your hardware and operating systems are compatible with the `puppet-agent` packages we publish.

> To install Puppet, first [view the pre-install tasks](./install_pre.html).

### Hardware

The Puppet agent service has no particular hardware requirements and can run on nearly anything.

However, the Puppet master service is fairly resource intensive, and should be installed on a robust dedicated server.

* At a minimum, your Puppet master server should have two processor cores and at least 1 GB of RAM.
* To comfortably serve at least 1,000 nodes, it should have 2-4 processor cores and at least 4 GB of RAM.

The demands on the Puppet master vary widely between deployments. The total needs are affected by the number of agents being served, how frequently those agents check in, how many resources are being managed on each agent, and the complexity of the manifests and modules in use.

### Puppet agent and operating system support life cycles

In PE 2015.2 and open source Puppet 4.0 and onward, we use the same Puppet agent packages in our open source and Puppet Enterprise ecosystems. Because of this, we've set guidelines for how we manage Puppet agent life cycles.

* Community-supported operating systems:

  On community-supported operating systems, we support Puppet agent for the operating system's life cycle. Essentially, Puppet stops publishing packages for a platform 30 days after its end-of-life (EOL) date. For example, Fedora 20 reached its EOL on June 23, 2015. This means on or around July 23, Puppet stopped providing fixes, updates, or support for either the Puppet Enterprise or open source versions of that agent package.

* Enterprise-class operating systems:

  On enterprise-class operating systems, we support Puppet agent for _at least_ the operating system's life cycle. In Puppet Enterprise, Puppet continues to support certain enterprise-class agent platforms after their EOL, though we do so solely at our own discretion.

### Platforms with packages

We publish and test official `puppet-agent` packages for these platforms. Less common and sometimes brand new platforms might not be automatically tested, but packages are still available for them.

For platforms supported in Puppet Enterprise, see its [system requirements]({{pe}}/sys_req_os.html).

| Operating system                           | Tested versions                                   | Untested versions       |
|--------------------------------------------|---------------------------------------------------|-------------------------|
| Red Hat Enterprise Linux (and derivatives) | 5, 6, 7                                           |                         |
| SUSE Linux Enterprise Server               | 11 (5.5.10 and earlier), 12 (5.5.10 and earlier), 15                                        |                         |
| Debian                                     | Jessie (8), Stretch (9)               |                         |
| Ubuntu                                     | 14.04, 16.04, 18.04 (5.5.2 and later)                 |                         |
| Fedora                                     | 26 (5.5.7 and earlier), 27 (5.5.8 and earlier), 28 (5.5.18 and earlier), 29 (5.5.19 and earlier)                                         |                         |
| Microsoft Windows (Server OS)              | 2008R2, 2012R2, 2016, 2019                        | 2008, 2012, 2019 (5.5.7 and later)              |
| Microsoft Windows (Consumer OS)            | 10 Enterprise                                     | 7, 8, 10         |
| macOS                                      | 10.12 Sierra, 10.13 High Sierra (5.5.18 and earlier), 10.14 Mojave, 10.15 Catalina |                         |

Red Hat Enterprise Linux derivatives include Amazon Linux v1 (using RHEL 6 packages) and v2 (using RHEL 7 packages).

On macOS 10.14 Mojave, you must grant Puppet Full Disk Access to be able to manage users and groups. To give Puppet access on a machine running macOS 10.14, go to `System Preferences > Security & Privacy > Privacy > Full Disk Access`, and add the path to the Puppet executable.

### Platforms without packages

Puppet and its prerequisites are known to run on the following platforms, but we do not provide official open source packages or perform automated testing.

-   Other Linux:
    -   Gentoo Linux
    -   Mandriva Corporate Server 4
    -   Arch Linux

-   Other Unix:
    -   Oracle Solaris, version 10 and higher
    -   AIX, version 6.1 and higher
    -   FreeBSD 4.7 and later
    -   OpenBSD 4.1 and later
    -   HP-UX

> **Note:** While installing `puppet-agent` on Solaris, you might see an error like the following:
> 
> ```
>  ERROR: attribute verification of </lib/svc/method/puppet.
>    pathname does not exist
> ```
>
> This is because you must have read-write access on the filesystem in order to install `puppet-agent`.

### Prerequisites

If you install Puppet via the official packages, you don't need to worry about prerequisites; your system's package manager handles all of them. These are only listed for those running Puppet from source or on unsupported systems.

* **Ruby:** We currently only test and package with 2.4.x versions of Ruby, therefore you should only use this version. Other interpreters and versions of Ruby are not covered by our tests.

* Mandatory libraries:

  * CFPropertyList 2.2 or later
  * [Hiera]({{hiera}}/) 3.2.1 or later
  * [Facter]({{facter}}/) 2.0 or later


* Optional libraries: The `msgpack` gem is required if you are using [msgpack serialization](./experiments_msgpack.html).
