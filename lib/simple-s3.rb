require 'rubygems'
require 'yaml'
require 'aws/s3'
require 'digest/md5'
require 'digest/sha1'
require 'net/https'
require 'base64'
puts "doing it"

%w{simple-s3 version}.each do |file|
  require File.dirname(__FILE__) + "/simple-s3/#{file}"
end
