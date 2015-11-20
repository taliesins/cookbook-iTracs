#
# Author:: Taliesin Sisson (<taliesins@yahoo.com>)
# Cookbook Name:: itracs
# Attributes:: default
# Copyright 2014-2015, Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default['itracs']['name'] = 'iTRACS Physical Layer Manager v9.0'
default['itracs']['filename'] = 'setup'
default['itracs']['filenameextension'] = 'msi'
default['itracs']['url'] = 'http://www.yourserver.com/' + default['itracs']['filename'] + '.' + default['itracs']['filenameextension'] 
default['itracs']['checksum'] = '1e194aa6252861ad1386479bbfb68d63720a2b6a3f3bd97961e6a89738b75aff'

default['itracs']['properties']['TARGETDIR'] = 'C:\\Program Files (x86)\\iTRACS Corp\\iTRACS Physical Layer Manager v9.0\\'
default['itracs']['properties']['PIDKEY'] = ''

default['itracs']['update']['filename'] = 'iTRACSUpdate'
default['itracs']['update']['version'] = '2170'
default['itracs']['update']['filenameextension'] = 'cab'
default['itracs']['update']['url'] = 'http://www.yourserver.com/' + default['itracs']['update']['filename'] + '.' + default['itracs']['update']['filenameextension'] 
default['itracs']['update']['checksum'] = '280092e0232a839b7015a3a4f3ca670160c80783f3d5dbadd741639e86bcbe8e'