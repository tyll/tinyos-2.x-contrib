#
# GNU cc for the AVR platform
#

%define src_name gcc

%include Solaris.inc
%include usr-gnu.inc

%define cc_is_gcc 1
%include base.inc

Summary: GNU gcc compiled for the AVR platform with TinyOS patches
Name: SFEavr-gcc-412
Version: 4.1.2
Release: 1
License: GNU GPLv2
Packager: MCerveny
Source: http://ftp.gnu.org/gnu/%{src_name}/%{src_name}-%{version}/%{src_name}-core-%{version}.tar.bz2
Group: Development/C

SUNW_BaseDir:        %{_basedir}
Meta(info.upstream): gcc@@gcc.gnu.org
Meta(info.maintainer): M.Cerveny@computer.org
Meta(info.repository_url): http://gcc.gnu.org/

BuildRoot:           %{_tmppath}/%{name}-%{version}-build

Patch1: avr-%{src_name}-%{version}-10-c-incpath.patch
Patch2: avr-%{src_name}-%{version}-11-exec-prefix.patch
Patch3: avr-%{src_name}-%{version}-20-libiberty-Makefile.in.patch
Patch4: avr-%{src_name}-%{version}-30-binary-constants.patch
Patch5: avr-%{src_name}-%{version}-31-isr-alias.patch
Patch6: avr-%{src_name}-%{version}-40-bug-28902.patch
Patch7: avr-%{src_name}-%{version}-42-bug-31137.patch
Patch8: avr-%{src_name}-%{version}-43-bug-19087.patch
Patch9: avr-%{src_name}-%{version}-44-bug-30289.patch
Patch10: avr-%{src_name}-%{version}-45-bug-18989.patch
Patch11: avr-%{src_name}-%{version}-46-bug-30483.patch
Patch12: avr-%{src_name}-%{version}-50-newdevices.patch
Patch13: avr-%{src_name}-%{version}-51-atmega256x.patch
Patch14: avr-%{src_name}-%{version}-52-rfa1.patch

%include default-depend.inc

Requires: SFEavr-binutils
BuildRequires: SFEavr-binutils

%description
GNU gcc compiled for the AVR platform. 

%prep
%setup -q -n %{src_name}-%{version}
cd %{_builddir}/%{src_name}-%{version}
mkdir builddir
%patch1 -p0
%patch2 -p0
%patch3 -p0
%patch4 -p0
%patch5 -p0
%patch6 -p0
%patch7 -p0
%patch8 -p0
%patch9 -p0
%patch10 -p0
%patch11 -p0
%patch12 -p0
%patch13 -p0
%patch14 -p0

#perl -w -pi.bak -e "s,^#\!\s*/bin/sh,#\!/usr/bin/bash," `find . -type f -name configure -exec /usr/xpg4/bin/grep -q "^#\!.*/bin/sh" {} \; -print`

%build

CPUS=`/usr/sbin/psrinfo | grep on-line | wc -l | tr -d ' '`
if test "x$CPUS" = "x" -o $CPUS = 0; then
     CPUS=1
fi

export CC=gcc
##export CXX=g++
##export CPP="cc -E -Xs"
export CFLAGS="-O"
#export CFLAGS="%optflags"
#export LDFLAGS="%{_ldflags}"
export PATH=$PATH:/usr/perl5/bin
export CONFIG_SHELL=/usr/bin/ksh

cd builddir
../configure --prefix=%{_prefix} \
            --libexecdir=%{_libexecdir} \
            --datadir=%{_datadir} \
            --sysconfdir=%{_sysconfdir} \
            --localstatedir=%{_localstatedir} \
            --infodir=%{_infodir} \
            --mandir=%{_mandir} \
	    --libexecdir=%{_libexecdir} \
            --disable-nls  \
            --disable-libssp \
            --enable-languages=c \
            --target=avr

make -j$CPUS

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT/%{_prefix}/include
rm -rf $RPM_BUILD_ROOT/%{_mandir}/man7
rm -rf $RPM_BUILD_ROOT/%{_infodir}/dir
for i in $(cd $RPM_BUILD_ROOT/%{_infodir}/; ls); do mv $RPM_BUILD_ROOT/%{_infodir}/$i $RPM_BUILD_ROOT/%{_infodir}/avr-$i; done

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,bin)
%dir %attr (0755, root, bin) %{_bindir}
%{_bindir}/*
%{_libdir}/gcc/avr/*
%{_prefix}/avr/*
%dir %attr (0755, root, sys) %{_datadir}
%{_datadir}/*
%{_infodir}/*

%changelog
* Mon Aug  8 2011 - Martin Cerveny
- Initial spec

