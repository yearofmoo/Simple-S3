class SimpleS3

  def self.config
    if @config.nil?
      @config = YAML.load_file('./simple-s3.yml')
    end
    @config
  end

  def self.upload!
    bucket      = @config['bucket'].to_s
    raise 'Simple-S3: Bucket not defined' if bucket.length == 0

    exclude     = @config['exclude_files'] || []
    inc         = @config['include_files'] || './**/*'
    metadata    = @config['metadata'] || {}
    metadata[:access] ||= 'public-read'

    files = []
    Dir[inc].each do |file|
      name = File.basename(file)
      found = false
      exclude.each do |ex|
        found = true if file.start_with?(ex) || ex == name
      end
      files.push(file) unless found
    end

    raise 'Simple-S3: No files found' if files.length == 0

    AWS::S3::Base.establish_connection!(
      :access_key_id     => @config['access_key'],
      :secret_access_key => @config['secret_key']
    )

    files.each do |file|
      base_name = File.basename(file)
      puts "Simple-S3: Uploading #{file} as '#{base_name}' to '#{bucket}'"
      AWS::S3::S3Object.store(
        base_name,
        File.open(file),
        bucket,
        meta_data
      )
    end

    puts "Simple-S3: Upload Completed!"
  end

end
