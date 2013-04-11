CONFIGDIR=${DESTDIR}/etc/birsh

install:
	mkdir -p ${CONFIGDIR}
	test -f ${CONFIGDIR}/settings || cp settings ${CONFIGDIR}/settings
	cp birsh ${DESTDIR}/usr/bin/
