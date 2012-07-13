# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="An audio/video SIP VoIP phone and instant messenger written in Java"
HOMEPAGE="http://www.jitsi.org/"
SRC_URI="https://download.jitsi.org/jitsi/src/jitsi-src-1.0-latest.zip"
# this download comes with 30 Mb of useless jars
# svn access is available but requires an account at java.net

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/jre:1.6"
DEPEND="virtual/jre:1.6
		dev-java/sun-jre-bin:1.6
		dev-java/xalan
		dev-java/ant-nodeps"

S="${WORKDIR}/jitsi"

src_compile() {
	ant rebuild || die
}

src_install() {
	insinto /usr/lib/jitsi/sc-bundles
	doins sc-bundles/*.jar sc-bundles/os-specific/linux/*.jar

	insinto /usr/lib/jitsi/lib
	doins lib/* lib/os-specific/linux/*
	doins -r lib/bundle

	insinto /usr/lib/jitsi/lib/native
	# WARNING: foreign binaries
	if [ `uname -m` = x86_64 ]; then
		doins lib/native/linux-64/*
	else
		doins lib/native/linux/*
	fi

	insinto /usr/share/pixmaps
	doins resources/install/debian/sip-communicator.svg
	#newins resources/install/debian/sip-communicator-32.xpm sip-communicator.xpm
	make_desktop_entry jitsi Jitsi sip-communicator "AudioVideo;Network;InstantMessaging;Chat;Telephony;VideoConference;Java;"

	sed -e 's/_PACKAGE_NAME_/jitsi/g' -e 's/_APP_NAME_/Jitsi/g' <resources/install/debian/sip-communicator.1.tmpl >jitsi.1
	doman jitsi.1

	cat resources/install/debian/sip-communicator.sh.tmpl | sed -e 's/exec $COMMAND $\*/GENTOO_VM=sun-jre-bin-1.6 exec $COMMAND $*/' | sed -e 's/_PACKAGE_NAME_/jitsi/g' > jitsi
	dobin jitsi
}
