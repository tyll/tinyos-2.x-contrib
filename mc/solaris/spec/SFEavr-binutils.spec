#
# GNU binutils for the AVR platform
#

%define src_name binutils

%include Solaris.inc
%include usr-gnu.inc

%define cc_is_gcc 1
%include base.inc

Summary: GNU binutils for the AVR platform
Name: SFEavr-binutils
Version: 2.19
Release: 1
License: GNU GPLv2
Packager: MCerveny
Source: http://ftp.gnu.org/gnu/%{src_name}/%{src_name}-%{version}.tar.bz2
Group: Development/GNU

SUNW_BaseDir:        %{_basedir}
Meta(info.upstream): binutils@sourceware.org
Meta(info.maintainer): M.Cerveny@computer.org
Meta(info.repository_url): http://www.gnu.org/s/binutils/

BuildRoot:           %{_tmppath}/%{name}-%{version}-build

Patch1: avr-%{src_name}-%{version}-30-avr-size.patch
Patch2: avr-%{src_name}-%{version}-31-avr-coff.patch
Patch3: avr-%{src_name}-%{version}-32-new-sections.patch
Patch4: avr-%{src_name}-%{version}-33-data-origin.patch
Patch5: avr-%{src_name}-%{version}-34-data-origin_more.patch
Patch6: avr-%{src_name}-%{version}-40-wrong-arch.patch
#Patch7: avr-%{src_name}-%{version}-50-xmega.patch
#Patch8: avr-%{src_name}-%{version}-51-xmega2.patch
#Patch9: avr-%{src_name}-%{version}-52-atmega32u6.patch
Patch10: avr-%{src_name}-%{version}-60-dollarsign.patch

%include default-depend.inc

%description
The GNU Binutils are a collection of binary tools. The main tools are 
ld and as for the AVR platform. 

%prep
%setup -q -n %{src_name}-%{version}
cd %{_builddir}/%{src_name}-%{version}
%patch1 -p0
%patch2 -p0
%patch3 -p0
%patch4 -p0
%patch5 -p0
%patch6 -p0
#%patch7 -p0
#%patch8 -p0
#%patch9 -p0
%patch10 -p0

perl -w -pi.bak -e "s,^#\!\s*/bin/sh,#\!/usr/bin/bash -xv," `find . -type f -name configure -exec /usr/xpg4/bin/grep -q "^#\!.*/bin/sh" {} \; -print`


%build

CPUS=`/usr/sbin/psrinfo | grep on-line | wc -l | tr -d ' '`
if test "x$CPUS" = "x" -o $CPUS = 0; then
     CPUS=1
fi

export CC=gcc
export CFLAGS="%optflags"
export LDFLAGS="%{_ldflags}"
export PATH=$PATH:/usr/perl5/bin

./configure --prefix=%{_prefix} \
            --libexecdir=%{_libexecdir} \
            --datadir=%{_datadir} \
            --sysconfdir=%{_sysconfdir} \
            --localstatedir=%{_localstatedir} \
            --infodir=%{_infodir} \
            --mandir=%{_mandir} \
	    --libexecdir=%{_libexecdir} \
            --disable-nls  \
            --disable-werror \
            --target=avr

make -j$CPUS

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT/%{_prefix}/lib
rm -rf $RPM_BUILD_ROOT/%{_infodir}/dir
for i in $(cd $RPM_BUILD_ROOT/%{_infodir}/; ls); do mv $RPM_BUILD_ROOT/%{_infodir}/$i $RPM_BUILD_ROOT/%{_infodir}/avr-$i; done

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,bin)
%dir %attr (0755, root, bin) %{_bindir}
%{_bindir}/*
%{_prefix}/avr/*
%dir %attr (0755, root, sys) %{_datadir}
%{_datadir}/*
%{_infodir}/*

%changelog
* Mon Aug  8 2011 - Martin Cerveny
- Initial spec

