rm ./*.gem
gem build simple-s3.gemspec
mv ./simple-s3*.gem ./simple-s3.gem
gem push simple-s3.gem
