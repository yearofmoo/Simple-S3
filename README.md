# Simple-S3

A super simple uploader for S3 using Ruby.

## Installation

Install as a gem using `gem install simple-s3` or place a `Gemfile` within your website directory with the following info:

```gemfile
source :rubygems
gem "simple-s3"
``` 

## Usage

Setup a file called `simple-s3.yml` with the following information:

```yaml
s3_bucket: '...'
s3_access_key: '...'
s3_secret_key: '...'
cloudfront_distribution_id: '...' # (optional)
```

And then run the command `simple-s3` from the command line within the same directory where your simple-s3.yml file is saved.

You can also include the library directly into another file (like a Rakefile for example):

```ruby
require 'rubygems'
require 'simple-s3'

# do some stuff
# run the uploader
SimpleS3.run!
# do other stuff
```

## Excluding Files

You can exclude files from the upload by defining a list of files within your simple-s3.yml file:

```yaml
exclude_files:
- one.html
- two.rb
- three.something

# ... the rest of the simple-s3.yml file
```

## Including Files

You can also include specific files for the upload

```yaml
include_files:
- "**/*" #default
- /path/to/some/other/file.rb

# ... the rest of the simple-s3.yml file
```

## More Info

Click here to view more information about this amazing gem.

http://www.yearofmoo.com/2012/10/launch-a-static-website-with-simple-s3.html
