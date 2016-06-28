# install-mimic &mdash; overwrite and preserve ownership

## Description

The `install-mimic` utility copies the specified files to the specified
destination (file or directory) similarly to `install(1)`, but it preserves
the ownership and access mode of the destination files.  This is useful when
updating files that have already been installed with locally modified copies
that may be owned by the current user and not by the desired owner of the
destination file (e.g. `root`).

### Examples:

Overwrite a system file with a local copy:

	install-mimic ./install-mimic.pl /usr/bin/install-mimic

Overwrite several files with local copies with the same name:

	install-mimic cinder/*.py /usr/lib/python2.7/dist-packages/cinder/

Install a new file similar to a system file:

	install-mimic -v -r /usr/bin/install-mimic install-none /usr/bin/

## Download

The source of the `install-mimic` utility may be obtained at
[its devel.ringlet.net homepage.][devel]  It is developed in
[a GitHub Git repository.][github]

The current version of `install-mimic` is **install_mimic-0.1.1**:

- [install-mimic-0.1.1.tar.gz][im-0.1.1.tar.gz] [(sig)][im-0.1.1.tar.gz.asc]
- [install-mimic-0.1.1.tar.bz2][im-0.1.1.tar.bz2] [(sig)][im-0.1.1.tar.bz2.asc]
- [install-mimic-0.1.1.tar.xz][im-0.1.1.tar.xz] [(sig)][im-0.1.1.tar.xz.asc]

Some older versions are also available:

- install-mimic-0.1.0
  + [install\_mimic-0.1.0.tar.gz][im-0.1.0.tar.gz] [(sig)][im-0.1.0.tar.gz.asc]
  + [install\_mimic-0.1.0.tar.bz2][im-0.1.0.tar.bz2] [(sig)][im-0.1.0.tar.bz2.asc]

## Version history

### 0.1.1 (2016-06-28)

- Add the internal "dist" target for creating distribution tarballs.
- Add a test suite.
- Reorder the functions a bit to avoid prototype declarations.
- Make the usage() function fatal by default.
- Add a Travis CI configuration file and a cpanfile.
- Move development from GitLab to GitHub.
- Switch the homepage URL to HTTPS.

### 0.1.0 (2015-06-02)

- First public release.

## Contact

Peter Pentchev <roam@ringlet.net>

[devel]: https://devel.ringlet.net/misc/install-mimic/
[github]: https://github.com/ppentchev/install-mimic

[im-0.1.0.tar.gz]: http://devel.ringlet.net/misc/install-mimic/install_mimic-0.1.0.tar.gz
[im-0.1.0.tar.gz.asc]: http://devel.ringlet.net/misc/install-mimic/install_mimic-0.1.0.tar.gz.asc
[im-0.1.0.tar.bz2]: http://devel.ringlet.net/misc/install-mimic/install_mimic-0.1.0.tar.bz2
[im-0.1.0.tar.bz2.asc]: http://devel.ringlet.net/misc/install-mimic/install_mimic-0.1.0.tar.bz2.asc

[im-0.1.1.tar.gz]: http://devel.ringlet.net/files/misc/install-mimic/install-mimic-0.1.1.tar.gz
[im-0.1.1.tar.gz.asc]: http://devel.ringlet.net/files/misc/install-mimic/install-mimic-0.1.1.tar.gz.asc
[im-0.1.1.tar.bz2]: http://devel.ringlet.net/files/misc/install-mimic/install-mimic-0.1.1.tar.bz2
[im-0.1.1.tar.bz2.asc]: http://devel.ringlet.net/files/misc/install-mimic/install-mimic-0.1.1.tar.bz2.asc
[im-0.1.1.tar.xz]: http://devel.ringlet.net/files/misc/install-mimic/install-mimic-0.1.1.tar.xz
[im-0.1.1.tar.xz.asc]: http://devel.ringlet.net/files/misc/install-mimic/install-mimic-0.1.1.tar.xz.asc
