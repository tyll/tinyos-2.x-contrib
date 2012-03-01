#
# avrdude in system programmer for AVR microcontrollers
#

%define src_name avrdude

%include Solaris.inc
%include usr-gnu.inc

%define cc_is_gcc 1
%include base.inc

# patch revert base.inc
%define _sysconfdir	   /etc/%{_subdir}

Summary: avrdude in system programmer for AVR microcontrollers
Name: SFEavrdude
Version: 5.10
Release: 1
License: GNU GPLv2
Packager: MCerveny
Source: http://download.savannah.gnu.org/releases/%{src_name}/%{src_name}-%{version}.tar.gz
Group: Development/Tools

SUNW_BaseDir:        /
Meta(info.upstream): avrdude-dev@nongnu.org
Meta(info.maintainer): M.Cerveny@computer.org
Meta(info.repository_url): http://www.nongnu.org/avrdude/

BuildRoot:           %{_tmppath}/%{name}-%{version}-build

%include default-depend.inc

%description
AVRDUDE is an open source utility to download/upload/manipulate the ROM
and EEPROM contents of AVR microcontrollers using the in-system
programming technique (ISP).

%prep
%setup -q -n %{src_name}-%{version}
cd %{_builddir}/%{src_name}-%{version}

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
	    --libexecdir=%{_libexecdir}

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
%dir %attr (0755, root, sys) %{_datadir}
%{_datadir}/*
%{_sysconfdir}/*

%changelog
* Mon Aug  8 2011 - Martin Cerveny
- Initial spec

