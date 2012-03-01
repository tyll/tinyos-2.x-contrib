#
# GNU binutils (add missing libraties)
#

%define src_name binutils

%include Solaris.inc
%include usr-gnu.inc

%define cc_is_gcc 1
%include base.inc

Summary: GNU binutils
Name: SFEbinutils-addon
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

%include default-depend.inc

Requires: developer/gnu-binutils
BuildRequires: developer/gnu-binutils

%description
The GNU Binutils are a collection of binary tools. This package provides unpacked libraries and headers.

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
rm -rf $RPM_BUILD_ROOT/%{_bindir}
rm -rf $RPM_BUILD_ROOT/%{_prefix}/i386-pc-solaris2.11
rm -rf $RPM_BUILD_ROOT/%{_datadir}
rm -rf $RPM_BUILD_ROOT/%{_std_datadir}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,bin)
%{_prefix}/*

%changelog
* Mon Aug  8 2011 - Martin Cerveny
- Initial spec

