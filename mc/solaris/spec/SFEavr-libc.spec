#
# C library for the AVR platform
#

%define src_name avr-libc

%include Solaris.inc
%include usr-gnu.inc

%include base.inc

Summary: C library for the AVR platform
Name: SFEavr-libc
Version: 1.7.1
Release: 1
License: Modified BSD License
Packager: MCerveny
Source: http://download.savannah.gnu.org/releases/%{src_name}/%{src_name}-%{version}.tar.bz2
Group: Development/Libraries

SUNW_BaseDir:        %{_basedir}
Meta(info.upstream): avr-gcc-list@nongnu.org
Meta(info.maintainer): M.Cerveny@computer.org
Meta(info.repository_url): http://www.nongnu.org/avr-libc/

BuildRoot:           %{_tmppath}/%{name}-%{version}-build

%include default-depend.inc

Requires: SFEavr-gcc
BuildRequires: SFEavr-gcc

%description
C library for the AVR platform.

%prep
%setup -q -n %{src_name}-%{version}
cd %{_builddir}/%{src_name}-%{version}

%build

CPUS=`/usr/sbin/psrinfo | grep on-line | wc -l | tr -d ' '`
if test "x$CPUS" = "x" -o $CPUS = 0; then
     CPUS=1
fi

export CC=avr-gcc
export PATH=$PATH:/usr/perl5/bin

./configure --prefix=%{_prefix} \
            --libexecdir=%{_libexecdir} \
            --datadir=%{_std_datadir} \
            --sysconfdir=%{_sysconfdir} \
            --localstatedir=%{_localstatedir} \
            --infodir=%{_infodir} \
            --mandir=%{_mandir} \
            --docdir=%{_std_datadir}/doc \
            --libexecdir=%{_libexecdir} \
            --build=`./config.guess` \
            --host=avr


make -j$CPUS

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,bin)
%dir %attr (0755, root, bin) %{_bindir}
%{_bindir}/*
%{_prefix}/avr/*
%{_std_datadir}/doc/*

%changelog
* Mon Aug  8 2011 - Martin Cerveny
- Initial spec

