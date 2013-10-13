# Description

[![Build Status](https://secure.travis-ci.org/realityforge/chef-elasticsearch.png?branch=master)](http://travis-ci.org/realityforge/chef-elasticsearch)

ElasticSearch cookbook!

# Requirements

## Platform:

*No platforms defined*

## Cookbooks:

* java
* ulimit
* authbind (Recommended but not required)

# Attributes

* `node['elasticsearch']['package_url']` -  Defaults to `https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{version}.tar.gz`.
* `node['elasticsearch']['extra_libraries']` -  Defaults to `Mash.new`.
* `node['elasticsearch']['user']` -  Defaults to `elasticsearch`.
* `node['elasticsearch']['group']` -  Defaults to `elasticsearch`.
* `node['elasticsearch']['base_dir']` -  Defaults to `/usr/local/elasticsearch`.
* `node['elasticsearch']['data_path']` -  Defaults to `/usr/local/elasticsearch/data`.
* `node['elasticsearch']['log_path']` -  Defaults to `/usr/local/elasticsearch/log`.
* `node['elasticsearch']['server']['interface']` -  Defaults to `0.0.0.0`.
* `node['elasticsearch']['server']['port']` -  Defaults to `9300`.
* `node['elasticsearch']['server']['http_port']` -  Defaults to `9200`.
* `node['elasticsearch']['index_auto_create_index']` -  Defaults to `true`.
* `node['elasticsearch']['index_mapper_dynamic']` -  Defaults to `true`.
* `node['elasticsearch']['index_shards']` -  Defaults to `5`.
* `node['elasticsearch']['index_replicas']` -  Defaults to `1`.
* `node['elasticsearch']['min_mem']` -  Defaults to `128m`.
* `node['elasticsearch']['max_mem']` -  Defaults to `512m`.
* `node['elasticsearch']['mlockall']` -  Defaults to `true`.
* `node['elasticsearch']['thread_stack_size']` -  Defaults to `256k`.
* `node['elasticsearch']['node_name']` -  Defaults to `node.name`.
* `node['elasticsearch']['cluster_name']` -  Defaults to `elasticsearch`.
* `node['elasticsearch']['discovery']['multicast']` -  Defaults to `true`.

# Recipes

* elasticsearch::default

# License and Maintainer

Maintainer:: Peter Donald (<peter@realityforge.org>)

License:: Apache 2.0
