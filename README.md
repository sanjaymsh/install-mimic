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

## Version history

### 0.1.1 (not yet)

- Add the internal "dist" target for creating distribution tarballs.
- Add a test suite.
- Reorder the functions a bit to avoid prototype declarations.
- Make the usage() function fatal by default.
- Add a Travis CI configuration file.

### 0.1.0 (2015-06-02)

- First public release.

## Contact

Peter Pentchev <roam@ringlet.net>

[devel]: http://devel.ringlet.net/misc/install-mimic/
[gitlab]: https://gitlab.com/ppentchev/install-mimic
