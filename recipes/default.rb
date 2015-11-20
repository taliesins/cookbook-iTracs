#
# Cookbook Name:: itracs
# Recipe:: default
#
# Copyright (C) 2015 Taliesin Sisson
#
# All rights reserved - Do Not Redistribute
#

if node['itracs']['properties']['PIDKEY'] == ""
	raise "Please configure itracs serial key in PIDKEY attribute"
end

include_recipe 'autoit'
include_recipe '7-zip'

::Chef::Recipe.send(:include, Windows::Helper)

working_directory = File.join(Chef::Config['file_cache_path'], '/itracs')
win_friendly_working_directory = win_friendly_path(working_directory)

itracs_install_script_path = File.join(working_directory, 'iTracsInstall.au3')
win_friendly_itracs_install_script_path = win_friendly_path(itracs_install_script_path)
itracs_installed = is_package_installed?("#{node['itracs']['name']}")
filename = File.basename(node['itracs']['url']).downcase
download_path = File.join(working_directory, filename)

template itracs_install_script_path do
  source 'iTracsInstall.au3.erb'
  variables(
    WorkingDirectory: win_friendly_working_directory
  )
  not_if {itracs_installed}
end

remote_file download_path do
  source node['itracs']['url']
  checksum node['itracs']['checksum']
  not_if {itracs_installed}
end

execute "Install #{node['itracs']['name']} with AutoIt" do
  command "\"#{File.join(node['autoit']['home'], 'AutoIt3.exe')}\" \"#{win_friendly_itracs_install_script_path}\""
  not_if {itracs_installed}
end

itracs_update_install_script_path = File.join(working_directory, 'iTracsUpgradeInstall.au3')
win_friendly_itracs_update_install_script_path = win_friendly_path(itracs_update_install_script_path)
update_directory = File.join(node['itracs']['properties']['TARGETDIR'], "PLM/Updater/_#{node['itracs']['update']['version']}")
itracs_update_installed = ::File.directory?(update_directory)
filename = File.basename(node['itracs']['update']['url']).downcase
download_path = File.join(working_directory, filename)

template itracs_update_install_script_path do
  source 'iTracsUpgradeInstall.au3.erb'
  variables(
    WorkingDirectory: win_friendly_working_directory
  )
  not_if {itracs_update_installed}
end

remote_file download_path do
  source node['itracs']['update']['url']
  checksum node['itracs']['update']['checksum']
  not_if {itracs_update_installed}
end

execute "Exract #{node['itracs']['name']} Update #{node['itracs']['update']['version']}" do
  command "\"#{File.join(node['7-zip']['home'], '7z.exe')}\" x -y -o\"#{win_friendly_working_directory}\" #{download_path}"
  only_if {itracs_update_installed}
end

execute "Install #{node['itracs']['name']} Update #{node['itracs']['update']['version']} with AutoIt" do
  command "\"#{File.join(node['autoit']['home'], 'AutoIt3.exe')}\" \"#{win_friendly_itracs_update_install_script_path}\""
  only_if {itracs_update_installed}
end
