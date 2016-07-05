# isos
CENTOS7_ISO_PATH=artifacts/centos-7.2.1511-everything.iso
CENTOS7_ISO_URL=https://mirrors.kernel.org/centos/7.2.1511/isos/x86_64/CentOS-7-x86_64-Everything-1511.iso
STACKI_ISO_PATH=artifacts/stacki-3.2-7.x.x86_64.disk1.iso
STACKI_ISO_URL=https://stacki.s3.amazonaws.com/public/pallets/3.2/open-source/stacki-3.2-7.x.x86_64.disk1.iso
# checksums and sigs
CENTOS7_ISO_GPGKEY=6341AB2753D78A78A7C27BB124C6A8A7F4A80EB5
CENTOS7_ISO_HASH_SIG_URL=https://mirrors.kernel.org/centos/7.2.1511/isos/x86_64/sha256sum.txt.asc
CENTOS7_ISO_HASH_SIG_PATH=artifacts/centos-7.2.1511-everything.sha256sums.txt.asc
CENTOS7_LOCKFILE=artifacts/centos-7.2.1511-everything.lock

all: build-stacki-7

download-centos7-everything:
	# test existence of the iso and conditionally download
	test -f ${CENTOS7_ISO_PATH} || \
		curl -o ${CENTOS7_ISO_PATH} "${CENTOS7_ISO_URL}"
	# download checksum signature
	test -f ${CENTOS7_ISO_HASH_SIG_PATH} || \
		curl -o ${CENTOS7_ISO_HASH_SIG_PATH} "${CENTOS7_ISO_HASH_SIG_URL}"
	# fetch key
	gpg --keyserver hkp://pgp.mit.edu --recv-keys ${CENTOS7_ISO_GPGKEY}
	# validate checksum signature
	gpg --verify ${CENTOS7_ISO_HASH_SIG_PATH} ${CENTOS7_ISO_HASH_PATH}
	# validate centos 7 iso
	test -f ${CENTOS7_LOCKFILE} || \
		sed 's:CentOS-7-x86_64-Everything-1511\.iso:artifacts/centos-7.2.1511-everything.iso:g' ${CENTOS7_ISO_HASH_SIG_PATH} | \
			grep 'centos-7.2.1511-everything.iso' | sha256sum -c -
	# create lockfile if it worked
	touch ${CENTOS7_LOCKFILE}

download-stacki:
	# test existence of the iso and conditionally download
	test -f ${STACKI_ISO_PATH} || \
		curl -o ${STACKI_ISO_PATH} ${STACKI_ISO_URL}

build-stacki-7: download-centos7-everything download-stacki
	echo true
