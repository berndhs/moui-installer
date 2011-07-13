# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.22
# 
# >> macros
# << macros

Name:       instalateur
Summary:    A shell-script based installer
Version:    0.1.4.2
Release:    1
Group:      Applications/System
License:    GPLv2+
URL:        https://github.com/berndhs/moui-installer
Source0:    instalateur-%{version}.tar.gz
Source100:  instalateur.yaml
Requires:   parted
Requires:   dialog
Requires:   rsync
Requires:   system-logos
Requires:   e2fsprogs
Requires:   btrfs-progs
Requires:   util-linux-ng
Requires:   syslinux-extlinux


%description
A shell-script based installer which implements the installation process in silent mode




%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre


make %{?jobs:-j%jobs}

# >> build post
# << build post
%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%make_install

# >> install post
# << install post






%files
%defattr(-,root,root,-)
# >> files

/etc/%{name}/post_install.sh
/usr/sbin/%{name}
/usr/sbin/liveinst

# << files


