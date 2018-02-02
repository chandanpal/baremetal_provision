# This kickstart file should only be used with RHEL 4, 5 and Fedora < 8.
# For newer distributions please use the sample_end.ks

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw cisco.123
# SELinux configuration
#selinux --disabled
selinux --permissive

# Do not configure the X Window System
skipx
# System timezone
timezone  America/New_York
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
# autopart
part /boot --fstype xfs --size 1008
part / --fstype xfs --size 256000


%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
$SNIPPET('func_install_if_enabled')
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
rm -f /etc/sysconfig/network-scripts/ifcfg-$IFNAME
chkconfig NetworkManager off
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')

#subscription-manager register --username=XXXXXXXXXXXXX --password=XXXXXXXXXXX --auto-attach
#yum -y install yum-utils
#subscription-manager repos --enable rhel-7-server-optional-rpms
#subscription-manager repos --enable rhel-7-server-extra-rpms

$SNIPPET('cobbler_register')
$SNIPPET('keybased_login')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps
%end
