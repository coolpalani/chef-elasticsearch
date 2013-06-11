include_recipe 'java'

group node['elasticsearch']['group'] do
end

user node['elasticsearch']['user'] do
  comment 'ElasticSearch User'
  gid node['elasticsearch']['group']
  home node['elasticsearch']['base_dir']
  shell '/bin/bash'
  system true
end

require 'digest/sha1'

cached_package_filename = "#{Chef::Config[:file_cache_path]}/elasticsearch-#{Digest::SHA1.hexdigest(node['elasticsearch']['package_url'])}/#{::File.basename(node['elasticsearch']['package_url'])}.tgz"
directory ::File.dirname(cached_package_filename) do
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode '0700'
  recursive true
end

remote_file cached_package_filename do
  source node['elasticsearch']['package_url']
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode "0600"
  action :create_if_missing
end

bash 'unpack_elasticsearch' do
  code <<-EOF
rm -rf /tmp/elasticsearch
mkdir /tmp/elasticsearch
cd /tmp/elasticsearch
tar --strip-components=1 -xzf #{cached_package_filename}
rm -rf bin conf LICENSE.txt NOTICE.txt README.textile
chown -R #{node['elasticsearch']['user']}:#{node['elasticsearch']['group']} /tmp/elasticsearch
chmod -R go-rwx /tmp/elasticsearch
mkdir -p #{File.dirname(node['elasticsearch']['base_dir'])}
rm -rf #{node['elasticsearch']['base_dir']}
mv /tmp/elasticsearch #{node['elasticsearch']['base_dir']}
test -d #{node['elasticsearch']['base_dir']}
  EOF
  not_if { ::File.exists?(node['elasticsearch']['base_dir']) }
end

service 'elasticsearch' do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :restart => true, :stop => true, :status => true
  action :nothing
end

extra_jars_dir = "#{node['elasticsearch']['base_dir']}/lib/extra"

directory extra_jars_dir do
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode '0700'
end

require 'digest/sha1'

extra_libraries = []

node['elasticsearch']['extra_libraries'].each_pair do |key, url|
  library_filename = "#{extra_jars_dir}/#{key}-#{Digest::SHA1.hexdigest(url)}/#{::File.basename(url)}"
  directory ::File.dirname(library_filename) do
    owner node['elasticsearch']['user']
    group node['elasticsearch']['group']
    mode '0700'
  end

  remote_file library_filename do
    source url
    mode '0600'
    owner node['elasticsearch']['user']
    group node['elasticsearch']['group']
    action :create_if_missing
  end
  extra_libraries << library_filename
end

directory "#{node['elasticsearch']['base_dir']}/config" do
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode '0700'
end

template "#{node['elasticsearch']['base_dir']}/config/logging.yml" do
  source 'logging.yml.erb'
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode '0600'
end

template "#{node['elasticsearch']['base_dir']}/config/elasticsearch.yml" do
  source 'elasticsearch.yml.erb'
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode '0600'
end

directory node['elasticsearch']['data_path'] do
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode '0700'
end

directory node['elasticsearch']['log_path'] do
  owner node['elasticsearch']['user']
  group node['elasticsearch']['group']
  mode '0700'
end

listen_ports = []
listen_ports << node['elasticsearch']['server']['port']
listen_ports << node['elasticsearch']['server']['http_port']

requires_authbind = listen_ports.any? { |p| p <= 1024 }
if requires_authbind
  include_recipe 'authbind'
end

template '/etc/init/elasticsearch.conf' do
  source 'upstart.conf.erb'
  mode '0600'
  cookbook 'elasticsearch'
  variables(:authbind => requires_authbind, :listen_ports => listen_ports, :extra_libraries => extra_libraries)
  notifies :restart, 'service[elasticsearch]', :delayed
end

user_ulimit node['elasticsearch']['user'] do
  filehandle_limit 32000
  memory_limit 'unlimited'
end

service 'elasticsearch' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action [:enable, :start]
end
