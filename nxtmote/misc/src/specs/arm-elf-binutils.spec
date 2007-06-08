# 
# 02/23/2007 arm
# target: arm
# version: 2.0tinyos
# release: 3
# nxtmote toolchain
# Adapted from avr and xscale specs
# @author Rasmus Pedersen

# test it with rpmbuild -bp binutils.spec

%define target   	arm-elf
%define tool		binutils
%define version  	2.17
%define release  	1
%define name 		%{target}-%{tool}
%define theprefix	/usr
%define source 		%{tool}-%{version}.tar.gz

Summary: GNU binutils for the %{target} platform
Name: %{name}
Version: %{version}
Release: %{release}
Packager: rup
URL: http://ftp.gnu.org/gnu/binutils/
Source0: %{source}
License: GNU GPL
Group: Development/Tools 
BuildRoot: %{_tmppath}/%{name}-root

%description
The GNU Binutils are a collection of binary tools. The main tools are 
ld and as.  

%prep
#echo dest: $RPM_BUILD_DIR/%{target}-%{name}-%{version}
rm -rf $RPM_BUILD_DIR/%{name}-%{version}
cd $RPM_SOURCE_DIR
wget ftp://ftp.gnu.org/gnu/binutils/%{source}
cd $RPM_BUILD_DIR
tar xzvf $RPM_SOURCE_DIR/%{source}
mv %{tool}-%{version} %{name}-%{version}
cd %{name}-%{version}

#can't get it to change into the right directory
#%setup -q -n %{name}-%{version}

%build
cd %{name}-%{version}
#./configure --target=%{target} --prefix=%{theprefix}
./configure --target=%{target} --prefix=%{buildroot}/%{theprefix} \
  --enable-interwork --enable-multilib --with-float=soft
make all 2>&1 | tee make.log

%install
#rm -rf %{buildroot}%{theprefix}
cd $RPM_BUILD_DIR/%{name}-%{version}
make prefix=%{buildroot}%{theprefix} install 2>&1 | tee make.log
cd %{buildroot}%{theprefix}
rm -rf info share  
rm lib/libiberty.a

%clean
cd $RPM_BUILD_DIR
rm -rf $RPM_BUILD_DIR/%{target}-%{name}-%{version}
rm -rf $RPM_SOURCE_DIR/%{target}-%{name}-%{version}.tar.gz

%files
%defattr(-,root,root)
%{theprefix}
%doc

%changelog
* Tue May 16 2007 rup <nxtmote@gmail.com>
- Uploading to tos web
