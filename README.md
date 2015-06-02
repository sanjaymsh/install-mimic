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
[a GitLab Git repository.][gitlab]

The current version of `install-mimic` is **install_mimic-0.1.0**:

- [install_mimic-0.1.0.tar.gz][im-0.1.0.tar.gz] [(sig)][im-0.1.0.tar.gz.asc]
- [install_mimic-0.1.0.tar.bz2][im-0.1.0.tar.bz2] [(sig)][im-0.1.0.tar.bz2.asc]

## Version history

### 0.1.0 (2015-06-02)

- First public release.

## Contact

Peter Pentchev <roam@ringlet.net>

[devel]: http://devel.ringlet.net/misc/install-mimic/
[gitlab]: https://gitlab.com/ppentchev/install-mimic

[im-0.1.0.tar.gz]: http://devel.ringlet.net/misc/install-mimic/install_mimic-0.1.0.tar.gz
[im-0.1.0.tar.gz.asc]: http://devel.ringlet.net/misc/install-mimic/install_mimic-0.1.0.tar.gz.asc
[im-0.1.0.tar.bz2]: http://devel.ringlet.net/misc/install-mimic/install_mimic-0.1.0.tar.bz2
[im-0.1.0.tar.bz2.asc]: http://devel.ringlet.net/misc/install-mimic/install_mimic-0.1.0.tar.bz2.asc
