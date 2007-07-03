# 
# The source must be in a tgz with the 
# name %{target}-%{version}-binutils.tgz.
# When unfolded, the top-level directory 
# must be %{target}-%{version}.
# 
# 02/23/2005 arm-elf
# target: arm-elf
# version: 4.1.2
# release: 1
#
# Note: Adapted froom xscale spec
# Note: Building the RPM requires the 

%define target 		arm-elf
%define tool 			gcc
%define version		4.1.2
%define release		1
%define name    	%{target}-%{tool}
%define theprefix /usr
%define source 		%{tool}-%{version}.tar.bz2

%define newlibname newlib-1.14.0

Summary: 	gcc compiled for the %{target} platform 
Name: 		%{name}
Version: 	%{version}
Release: 	%{release}
Packager: 	rup
License: 	GNU GPL
Group: 		Development/Tools
URL: 		ftp://ftp.gnu.org/pub/gnu/gcc/gcc-4.1.2/gcc-core-4.1.2.tar.bz2
Source: 	%{tool}-%{version}.tar.bz2
Source1:	%{newlibname}.tar.gz
BuildRoot:	%{_tmppath}/%{name}-root
BuildRequires: 	arm-elf-binutils

%description
gcc compiled for the %{target} platform.  

%prep
rm -rf $RPM_BUILD_DIR/%{name}-%{version}
rm -rf $RPM_BUILD_DIR/%{tool}-%{version}.tar
rm -rf $RPM_BUILD_DIR/%{newlibname}
rm -rf %{buildroot}/build-gcc
rm -rf %{buildroot}/build-newlib
rm -rf %{buildroot}%{theprefix}
mkdir -p %{buildroot}%{theprefix}
mkdir -p %{buildroot}/build-gcc
mkdir -p %{buildroot}/build-newlib

#Get the sources
echo Getting the newlib and gcc sources...
cd $RPM_SOURCE_DIR
wget ftp://sources.redhat.com/pub/newlib/%{newlibname}.tar.gz
wget ftp://ftp.gnu.org/gnu/gcc/gcc-%{version}/%{source}
wget http://gnuarm.com/t-arm-elf

#Unpack the gcc source
#%setup -q
echo Renaming the gcc package to fit other tos specs...
cd $RPM_BUILD_DIR
cp $RPM_SOURCE_DIR/%{source} .
bunzip2 %{source}
tar xvf %{tool}-%{version}.tar
mv %{tool}-%{version} %{name}-%{version}
cp $RPM_SOURCE_DIR/t-arm-elf %{name}-%{version}/gcc/config/arm

#Unpack the newlib source
echo Renaming the newlib package to fit other tos specs...
cp $RPM_SOURCE_DIR/%{newlibname}.tar.gz .
tar xzvf %{newlibname}.tar.gz
#move newlib in here
#mv %{newlibname}/newlib %{name}-%{version}

#unpack the newlib source on the same directory level as gcc
#%setup -q -T -D -b 1
#pwd is now gcc sources
echo Starting to build gcc pass 1...
%build
#PATH=$PATH:%{buildroot}/build-gcc/bin
cd %{buildroot}/build-gcc
$RPM_BUILD_DIR/%{name}-%{version}/configure --target=%{target} \
	--prefix=%{buildroot}%{theprefix} --with-newlib \
	--enable-languages=c --enable-interwork \
	--enable-multilib --with-float=soft \
	--with-headers=$RPM_BUILD_DIR/%{newlibname}/newlib/libc/include \
make all-gcc install-gcc 2>&1 | tee make.log

#newlibbuild
cd %{buildroot}/build-newlib
$RPM_BUILD_DIR/%{newlibname}/configure --target=%{target} \
	--prefix=%{buildroot}%{theprefix} --enable-interwork \
	--enable-multilib --with-float=soft
make all install 2>&1 | tee make.log

%install
#Should the bootstrap gcc be removed first?
echo Starting the install pass of the gcc building process...
cd %{buildroot}/build-gcc
make all install 2>&1 | tee make.log
cd ..
#echo ECHO %{buildroot}%{theprefix}
rm -rf %{buildroot}/build-gcc
rm -rf %{buildroot}/build-newlib
cd %{buildroot}%{theprefix}
rm -rf info man
#rm -rf share 
#rm lib/libiberty.a

#make prefix=%{buildroot}%{theprefix} install
#cd %{buildroot}%{theprefix}
#rm lib/libiberty.a

%clean
echo Cleaning up...
rm -rf $RPM_BUILD_DIR/%{name}-%{version}
#rm -rf $RPM_SOURCE_DIR/%{name}-%{version}
rm -rf $RPM_BUILD_DIR/%{newlibname}
rm -rf %{buildroot}/build-gcc
rm -rf %{buildroot}/build-newlib

%files
%defattr(-,root,root,-)
%{theprefix}
%doc

%changelog
* Wed May 16 2007 rup
- wget
* Wed Feb 28 2007 rup
- Adapted for arm-elf gcc
