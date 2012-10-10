require 'rubygems'
require 'yaml'
require 'aws/s3'

%w{simple-s3}.each do |file|
  require File.dirname(__FILE__) + "/simple-s3/#{file}"
end
