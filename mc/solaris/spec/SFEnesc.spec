#
# nesC compiler
#

%define src_name nesc

%include Solaris.inc
%include usr-gnu.inc

%define cc_is_gcc 1
%include base.inc

Summary: nesC compiler
Name: SFEnesc
Version: 1.3.3
Release: 1
License: GNU GPLv2
Packager: MCerveny
Source: http://sourceforge.net/projects/nescc/files/nescc/v%{version}/%{src_name}-%{version}.tar.gz
Group: Development/Other Languages

SUNW_BaseDir:        %{_basedir}
Meta(info.upstream): nescc-devel@lists.sourceforge.net
Meta(info.maintainer): M.Cerveny@computer.org
Meta(info.repository_url): http://nescc.sourceforge.net/

BuildRoot:           %{_tmppath}/%{name}-%{version}-build

Patch1: %{src_name}-%{version}-10-linedef.patch

%include default-depend.inc

%description
nesC is a compiler for a C-based language designed to support embedded
systems including TinyOS. nesC provides several advantages for the
TinyOS compiler infrastructure: improved syntax, support for full type
safety, abundant error reporting, generic components, and Java-like
interfaces.

%prep
%setup -q -n %{src_name}-%{version}
cd %{_builddir}/%{src_name}-%{version}
%patch1 -p0

%build

CPUS=`/usr/sbin/psrinfo | grep on-line | wc -l | tr -d ' '`
if test "x$CPUS" = "x" -o $CPUS = 0; then
     CPUS=1
fi

export CC="gcc"
export CFLAGS="%optflags"
export LDFLAGS="%{_ldflags}"
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
%{_libdir}/*
%dir %attr (0755, root, sys) %{_datadir}
%{_datadir}/*
%dir %attr (0755, root, sys) %{_std_datadir}
%{_std_datadir}/*

%changelog
* Mon Aug  8 2011 - Martin Cerveny
- Initial spec

