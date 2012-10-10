class SimpleS3

  def config
    if @config.nil?
      @config = YAML.load('./simple-s3.yml')
    end
    @config
  end

  def upload!
    exclude     = @config['exclude_files']
    inc         = @config['include_files']
    bucket      = @config['bucket']
    metadata    = @config['metadata'] || {}

    metadata[:access] ||= 'public-read'

    files = []
    Dir[inc].each do |file|
      name = File.basename(file)
      files.push(file) unless exclude.include?(name)
    end

    AWS::S3::Base.establish_connection!(
      :access_key_id     => @config['access_key'],
      :secret_access_key => @config['secret_key']
    )

    files.each do |file|
      base_name = File.basename(file)
      puts "Uploading #{file} as '#{base_name}' to '#{bucket}'"
      AWS::S3::S3Object.store(
        base_name,
        File.open(file),
        bucket,
        meta_data
      )
    end

    puts "Completed!"
  end

end
