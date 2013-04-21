version = '0.20.6'
default['elasticsearch']['package_url']  = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{version}.tar.gz"
default['elasticsearch']['extra_libraries'] = Mash.new

default['elasticsearch']['user']      = 'elasticsearch'
default['elasticsearch']['group']     = 'elasticsearch'
default['elasticsearch']['base_dir']  = '/usr/local/elasticsearch'
default['elasticsearch']['data_path'] = '/usr/local/elasticsearch/data'
default['elasticsearch']['log_path']  = '/usr/local/elasticsearch/log'

# === Server ===
#
default['elasticsearch']['server']['interface'] = '0.0.0.0'
default['elasticsearch']['server']['port'] = 9300
default['elasticsearch']['server']['http_port'] = 9200

# === INDEX ===
#
default['elasticsearch']['index_auto_create_index'] = true
default['elasticsearch']['index_mapper_dynamic']    = true
default['elasticsearch']['index_shards']   = '5'
default['elasticsearch']['index_replicas'] = '1'

# === MEMORY ===
#
default['elasticsearch']['min_mem']  = '128m'
default['elasticsearch']['max_mem']  = '512m'
default['elasticsearch']['mlockall'] = true
default['elasticsearch']['thread_stack_size']  = '256k'

# === SETTINGS ===
#
default['elasticsearch']['node_name']      = node.name
default['elasticsearch']['cluster_name']   = 'elasticsearch'


# === SETTINGS ===
#
default['elasticsearch']['discovery']['multicast'] = true
