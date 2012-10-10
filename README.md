# Simple-S3

A super simple uploader for S3 using Ruby.

## Installation

Install as a gem using `gem install simple-s3`.

## Usage

Setup a file called `simple-s3.yml` with the following information:

```yaml
s3_bucket: '...'
s3_access_key: '...'
s3_secret_key: '...'
cloudfront_distribution_id: '...'
```

And then run the command `simple-s3` from the command line within the same directory where your simple-s3.yml file is saved.

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
- **/* #default
- /path/to/some/other/file.rb

# ... the rest of the simple-s3.yml file
```
