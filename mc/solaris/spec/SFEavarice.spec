#
# Interface for GDB to Atmel AVR JTAGICE in circuit emulator.
#

%define src_name avarice

%include Solaris.inc
%include usr-gnu.inc

%define cc_is_gcc 1
%include base.inc

# patch revert base.inc
%define _sysconfdir	   /etc/%{_subdir}

Summary: Interface for GDB to Atmel AVR JTAGICE in circuit emulator.
Name: SFEavarice
Version: 2.12
Release: 1
License: GNU GPLv2
Packager: MCerveny
Source: http://downloads.sourceforge.net/sourceforge/%{src_name}/%{src_name}-%{version}.tar.bz2
Group: Development/Tools

SUNW_BaseDir:        /
Meta(info.upstream): avarice-user@lists.sourceforge.net
Meta(info.maintainer): M.Cerveny@computer.org
Meta(info.repository_url): http://avarice.sourceforge.net/

BuildRoot:           %{_tmppath}/%{name}-%{version}-build

Patch1: %{src_name}-%{version}-20-ioregisters.patch
Patch2: %{src_name}-%{version}-30-usbthread.patch

%include default-depend.inc

%description
AVaRICE is a program which interfaces the GNU Debugger with the AVR JTAG ICE
available from Atmel.

%prep
%setup -q -n %{src_name}-%{version}
cd %{_builddir}/%{src_name}-%{version}
%patch1 -p1
%patch2 -p1

%build

CPUS=`/usr/sbin/psrinfo | grep on-line | wc -l | tr -d ' '`
if test "x$CPUS" = "x" -o $CPUS = 0; then
     CPUS=1
fi

export CC=gcc
export CXX=g++
export CFLAGS="%optflags -I%{_includedir}"
export CXXFLAGS="%optflags -I%{_includedir}"
export LDFLAGS="%{_ldflags} -L%{_libdir} -R%{_libdir}"
export PATH=$PATH:/usr/perl5/bin

./configure --prefix=%{_prefix} \
            --libexecdir=%{_libexecdir} \
            --datadir=%{_std_datadir} \
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
%{_std_datadir}/*

%changelog
* Mon Feb 27 2012 - Martin Cerveny
  - updated to 2.12
* Mon Aug  8 2011 - Martin Cerveny
- Initial spec

