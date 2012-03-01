#
# GNU cc for the AVR platform
#

%define src_name gcc

%include Solaris.inc
%include usr-gnu.inc

%define cc_is_gcc 1
%include base.inc

Summary: GNU gcc compiled for the AVR platform
Name: SFEavr-gcc
Version: 4.5.3
Release: 1
License: GNU GPLv3+
Packager: MCerveny
Source: http://ftp.gnu.org/gnu/%{src_name}/%{src_name}-%{version}/%{src_name}-core-%{version}.tar.bz2
Group: Development/C

SUNW_BaseDir:        %{_basedir}
Meta(info.upstream): gcc@@gcc.gnu.org
Meta(info.maintainer): M.Cerveny@computer.org
Meta(info.repository_url): http://gcc.gnu.org/

BuildRoot:           %{_tmppath}/%{name}-%{version}-build

%include default-depend.inc

Requires: SFEavr-binutils
Requires: SFEmpfr 
#>= 2.3.1
Requires: SFEgmp 
#>= 4.2
Requires: SFElibmpc 
#>= 0.8.0
BuildRequires: SFEavr-binutils
BuildRequires: SFEmpfr
BuildRequires: SFEgmp
BuildRequires: SFElibmpc

%description
GNU gcc compiled for the AVR platform. 

%prep
%setup -q -n %{src_name}-%{version}
cd %{_builddir}/%{src_name}-%{version}
mkdir buildsubdir

#perl -w -pi.bak -e "s,^#\!\s*/bin/sh,#\!/usr/bin/bash," `find . -type f -name configure -exec /usr/xpg4/bin/grep -q "^#\!.*/bin/sh" {} \; -print`

%build

CPUS=`/usr/sbin/psrinfo | grep on-line | wc -l | tr -d ' '`
if test "x$CPUS" = "x" -o $CPUS = 0; then
     CPUS=1
fi

export CC=gcc
#export CXX=g++
#export CPP="cc -E -Xs"
export CFLAGS="-O"
#export CFLAGS="%optflags"
#export LDFLAGS="%{_ldflags}"
export LDFLAGS="-L/usr/gnu/lib -R/usr/gnu/lib"
export PATH=$PATH:/usr/perl5/bin
export CONFIG_SHELL=/usr/bin/ksh

cd buildsubdir
../configure --prefix=%{_prefix} \
            --libexecdir=%{_libexecdir} \
            --datadir=%{_datadir} \
            --sysconfdir=%{_sysconfdir} \
            --localstatedir=%{_localstatedir} \
            --infodir=%{_infodir} \
            --mandir=%{_mandir} \
	    --libexecdir=%{_libexecdir} \
\
            --with-gmp=/usr/gnu \
            --with-mpfr=/usr/gnu \
            --with-mpc=/usr/gnu \
\
            --with-gcc \
            --with-gnu-ld \
            --with-gnu-as \
            --with-dwarf2 \
\
            --disable-nls  \
            --disable-libssp \
            --disable-werror \
            --disable-shared \
            --disable-threads \
            --enable-languages=c \
            --target=avr

make -j$CPUS

%install
rm -rf $RPM_BUILD_ROOT
cd buildsubdir
make install DESTDIR=$RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT/%{_prefix}/include
rm -rf $RPM_BUILD_ROOT/%{_prefix}/avr
rm -rf $RPM_BUILD_ROOT/%{_mandir}/man7
rm -rf $RPM_BUILD_ROOT/%{_infodir}/dir
rm -rf $RPM_BUILD_ROOT/%{_libdir}/libiberty.a
for i in $(cd $RPM_BUILD_ROOT/%{_infodir}/; ls); do mv $RPM_BUILD_ROOT/%{_infodir}/$i $RPM_BUILD_ROOT/%{_infodir}/avr-$i; done

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,bin)
%dir %attr (0755, root, bin) %{_bindir}
%{_bindir}/*
%{_libdir}/gcc/avr/*
%dir %attr (0755, root, sys) %{_datadir}
%{_datadir}/*
%{_infodir}/*

%changelog
* Mon Aug 10 2011 - Martin Cerveny
- Initial spec

