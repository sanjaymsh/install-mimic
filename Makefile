# Copyright (c) 2015, 2016  Peter Pentchev
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

PACKAGE=	install-mimic
VERSION=	`perl install-mimic.pl -V | awk "{print \\$$2}"`

PKG_DIR?=	..
PKG_TAR=	${PKG_DIR}/${PACKAGE}-${VERSION}.tar

SCRIPTS?=	install-mimic
MAN1?=		install-mimic.1.gz

PREFIX?=	/usr
BINDIR?=	${PREFIX}/bin
SHAREDIR?=	${PREFIX}/share
MANDIR?=	${PREFIX}/share/man/man

CP?=		cp
ECHO?=		echo
GZIP?=		gzip -c9
INSTALL?=	install
MKDIR?=		mkdir -p
RM?=		rm -f
LN_S?=		ln -s

BINOWN?=	root
BINGRP?=	root
BINMODE?=	755

SHAREOWN?=	${BINOWN}
SHAREGRP?=	${BINGRP}
SHAREMODE?=	644

COPY?=		-c
STRIP?=		-s
INSTALL_PROGRAM?=	${INSTALL} ${COPY} ${STRIP} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
INSTALL_SCRIPT?=	${INSTALL} ${COPY} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
INSTALL_DATA?=	${INSTALL} ${COPY} -o ${SHAREOWN} -g ${SHAREGRP} -m ${SHAREMODE}

all:		${SCRIPTS} ${MAN1}

%:		%.pl
		${CP} $< $@

%.1.gz:		%.1
		${GZIP} $< > $@

install:	all
		${MKDIR} ${DESTDIR}${BINDIR}
		${INSTALL_SCRIPT} ${SCRIPTS} ${DESTDIR}${BINDIR}
		${MKDIR} ${DESTDIR}${MANDIR}1
		${INSTALL_DATA} ${MAN1} ${DESTDIR}${MANDIR}1

test:		all
		@printf "\n===== Testing the Perl 5 implementation\n\n"
		[ -x install-mimic.pl ] || chmod +x install-mimic.pl
		env INSTALL_MIMIC=./install-mimic.pl prove t

clean:
		${RM} ${SCRIPTS} ${MAN1}

dist:
		[ -n "$$ALLOW_DIST_DEV" ] || devver
		@printf "\n===== Creating %s.*\n\n" "${PKG_TAR}"
		git archive --format=tar --prefix="${PACKAGE}-${VERSION}/" -o "${PKG_TAR}" HEAD || (rm -f -- "${PKG_TAR}"; false)
		gzip -nc9 "${PKG_TAR}" > "${PKG_TAR}.gz" || (rm -f -- "${PKG_TAR}.gz"; false)
		bzip2 -c9 "${PKG_TAR}" > "${PKG_TAR}.bz2" || (rm -f -- "${PKG_TAR}.bz2"; false)
		xz -c9 "${PKG_TAR}" > "${PKG_TAR}.xz" || (rm -f -- "${PKG_TAR}.xz"; false)
		rm -- "${PKG_TAR}"
		@printf "\n===== Created %s.*\n\n" "${PKG_TAR}"

.PHONY:		all install test clean dist
