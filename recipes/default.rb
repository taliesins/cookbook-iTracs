#
# Cookbook Name:: itracs
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

if node['itracs']['properties']['PIDKEY'] == ""
	raise "Please configure itracs serial key in PIDKEY attribute"
end

windows_package node['itracs']['name'] do
	checksum node['itracs']['checksum']
	source node['itracs']['url']
	installer_type :msi
	options "/qn TARGETDIR=\"#{node['itracs']['properties']['TARGETDIR']}\" PIDKEY=\"#{node['itracs']['properties']['PIDKEY']}\""
end