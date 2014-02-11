# JJG-Ansible-Windows

Windows shell provisioning script to bootstrap Ansible from within a Vagrant VM running on Windows.

This script is configured to use configure RHEL-based VM (Fedora, CentOS, etc.) so it can run Ansible playbooks from within the VM through Vagrant.

Read more about this script, and other techniques for using Ansible within a Windows environment, on Server Check.in: [Running Ansible within Windows](https://servercheck.in/blog/running-ansible-within-windows).

## Usage

In your Vagrantfile, use a conditional provisioning statement if you want to use this script (which runs Ansible from within the VM instead of on your host—this example assumes your playbook and the inventory file are all within a 'provisioning' folder, and this script is within provisioning/JJG-Ansible-Windows):

```ruby
# Use rbconfig to determine if we're on a windows host or not.
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
if is_windows
  # Provisioning configuration for shell script.
  config.vm.provision "shell" do |sh|
    sh.path = "provisioning/JJG-Ansible-Windows/windows.sh"
    sh.args = "provisioning/playbook.yml provisioning/inventory"
  end
else
  # Provisioning configuration for Ansible (for Mac/Linux hosts).
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.inventory_path = "provisioning/inventory"
    ansible.sudo = true
  end
end
```

## Licensing and More Info

Created by [Jeff Geerling](http://jeffgeerling.com/) in 2014. Licensed under the MIT license; see the LICENSE file for more info.
