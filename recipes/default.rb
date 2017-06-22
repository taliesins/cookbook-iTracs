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
include_recipe 'seven_zip'

::Chef::Recipe.send(:include, Windows::Helper)

working_directory = File.join(Chef::Config['file_cache_path'], '/itracs')
win_friendly_working_directory = win_friendly_path(working_directory)

directory working_directory do
  recursive true
end

itracs_install_script_path = File.join(working_directory, 'iTracsInstall.au3')
itracs_install_exe_path = File.join(working_directory, 'iTracsInstall.exe')
win_friendly_itracs_install_script_path = win_friendly_path(itracs_install_script_path)
win_friendly_itracs_install_exe_path = win_friendly_path(itracs_install_exe_path)

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

execute "Check syntax #{win_friendly_itracs_install_script_path} with AutoIt" do
  command "\"#{File.join(node['autoit']['home'], '/Au3Check.exe')}\" \"#{win_friendly_itracs_install_script_path}\""
  not_if {itracs_installed}
end

execute "Compile #{win_friendly_itracs_install_script_path} with AutoIt" do
  command "\"#{File.join(node['autoit']['home'], '/Aut2Exe/Aut2exe.exe')}\" /in \"#{win_friendly_itracs_install_script_path}\" /out \"#{win_friendly_itracs_install_exe_path}\""
  not_if {itracs_installed}
end

remote_file download_path do
  source node['itracs']['url']
  checksum node['itracs']['checksum']
  not_if {itracs_installed}
end

execute "Install #{win_friendly_itracs_install_exe_path}" do
  command "\"#{File.join(node['pstools']['home'], 'psexec.exe')}\" -accepteula -i -s \"#{win_friendly_itracs_install_exe_path}\""
  not_if {itracs_installed}
end

windows_feature "NetFx3" do
  action :install
  all true
end

itracs_update_install_script_path = File.join(working_directory, 'iTracsUpgradeInstall.au3')
itracs_update_install_exe_path = File.join(working_directory, 'iTracsUpgradeInstall.exe')
win_friendly_itracs_update_install_script_path = win_friendly_path(itracs_update_install_script_path)
win_friendly_itracs_update_install_exe_path = win_friendly_path(itracs_update_install_exe_path)
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

execute "Check syntax #{win_friendly_itracs_update_install_script_path} with AutoIt" do
  command "\"#{File.join(node['autoit']['home'], '/Au3Check.exe')}\" \"#{win_friendly_itracs_update_install_script_path}\""
  not_if {itracs_update_installed}
end

execute "Compile #{win_friendly_itracs_update_install_script_path} with AutoIt" do
  command "\"#{File.join(node['autoit']['home'], '/Aut2Exe/Aut2exe.exe')}\" /in \"#{win_friendly_itracs_update_install_script_path}\" /out \"#{win_friendly_itracs_update_install_exe_path}\""
  not_if {itracs_update_installed}
end

remote_file download_path do
  source node['itracs']['update']['url']
  checksum node['itracs']['update']['checksum']
  not_if {itracs_update_installed}
end

execute "Exract #{download_path} To #{win_friendly_working_directory}" do
  command "\"#{File.join(node['seven_zip']['home'], '7z.exe')}\" x -y -o\"#{win_friendly_working_directory}\" #{download_path}"
  not_if {itracs_update_installed}
end

execute "Install #{win_friendly_itracs_update_install_exe_path}" do
  command "\"#{File.join(node['pstools']['home'], 'psexec.exe')}\" -accepteula -i -s \"#{win_friendly_itracs_update_install_exe_path}\""
  not_if {itracs_update_installed}
end