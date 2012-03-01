#
# GNU gdb for the AVR platform
#

%define src_name gdb

%include Solaris.inc
%include usr-gnu.inc

%define cc_is_gcc 1
%include base.inc

Summary: GNU gdb debugger for the AVR platform.
Name: SFEavr-gdb
Version: 7.3
Release: 1
License: GNU GPLv3
Packager: MCerveny
Source: http://ftp.gnu.org/gnu/%{src_name}/%{src_name}-%{version}.tar.bz2
Group: Development/System

SUNW_BaseDir:        %{_basedir}
Meta(info.upstream): gdb@sourceware.org
Meta(info.maintainer): M.Cerveny@computer.org
Meta(info.repository_url): http://www.gnu.org/s/gdb/

BuildRoot:           %{_tmppath}/%{name}-%{version}-build

Patch1: avr-%{src_name}-%{version}-10-remote.patch

%include default-depend.inc

Requires: SFEavr-binutils
Requires: SFEgmp
Requires: SFEmpfr
BuildRequires: SFEavr-binutils
BuildRequires: SFEgmp
BuildRequires: SFEmpfr

%description
GNU gdb compiled for the AVR platform. 

%prep
%setup -q -n %{src_name}-%{version}
cd %{_builddir}/%{src_name}-%{version}
%patch1 -p0

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

./configure --prefix=%{_prefix} \
            --libexecdir=%{_libexecdir} \
            --datadir=%{_std_datadir} \
            --sysconfdir=%{_sysconfdir} \
            --localstatedir=%{_localstatedir} \
            --infodir=%{_infodir} \
            --mandir=%{_mandir} \
	    --libexecdir=%{_libexecdir} \
            --disable-nls  \
            --with-gmp=/usr/gnu \
            --with-mpfr=/usr/gnu \
            --disable-tui \
            --target=avr

make -j$CPUS

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT/%{_libdir}/libiberty.a
rm -rf $RPM_BUILD_ROOT/%{_infodir}/dir
rm -rf $RPM_BUILD_ROOT/%{_infodir}/bfd.info
for i in $(cd $RPM_BUILD_ROOT/%{_infodir}/; ls); do mv $RPM_BUILD_ROOT/%{_infodir}/$i $RPM_BUILD_ROOT/%{_infodir}/avr-$i; done

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,bin)
%dir %attr (0755, root, bin) %{_bindir}
%{_bindir}/*
%{_libdir}/*
%dir %attr (0755, root, sys) %{_datadir}
%{_datadir}/*
%{_std_datadir}/*

%changelog
* Mon Aug  8 2011 - Martin Cerveny
- Initial spec

