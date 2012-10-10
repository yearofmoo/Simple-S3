class SimpleS3

  def self.config
    if @config.nil?
      path = './simple-s3.yml'
      raise "Simple-S3: Config file not found #{path}" unless File.exist?(path)
      @config = YAML.load_file(path)
    end
    @config
  end

  def self.default_exclude_files
    ['simple-s3.yml', '.git', '.rvmrc', 'Gemfile', 'Gemfile.lock', '.gitignore', '.gitmodules']
  end

  def self.s3_access_key
    self.config['s3_access_key']
  end

  def self.s3_secret_key
    self.config['s3_secret_key']
  end

  def self.s3_bucket
    self.config['s3_bucket']
  end

  def self.cloudfront_distribution_id
    self.config['cloudfront_distribution_id']
  end

  def self.run!
    self.upload!
    self.invalidate!
  end

  def self.upload!
    bucket      = self.s3_bucket
    raise 'Simple-S3: Bucket not defined' if bucket.length == 0

    exclude     = config['exclude_files'] || []
    exclude |= self.default_exclude_files
    inc         = config['include_files'] || './**/*'
    metadata    = config['metadata'] || {}
    metadata[:access] ||= 'public-read'

    inc = [inc] unless inc.is_a?(Array)

    files = []
    inc.each do |ii|
      Dir[ii].each do |file|
        name = File.basename(file)
        found = false
        exclude.each do |ex|
          found = true if file.start_with?(ex) || ex == name
        end
        files.push(file) unless found
      end
    end

    raise 'Simple-S3: No files found' if files.length == 0

    AWS::S3::Base.establish_connection!(
      :access_key_id     => self.s3_access_key,
      :secret_access_key => self.s3_secret_key
    )

    files.each do |file|
      base_name = File.basename(file)
      puts "Simple-S3: Uploading #{file} as '#{base_name}' to '#{bucket}'"
      AWS::S3::S3Object.store(
        base_name,
        File.open(file),
        bucket,
        metadata
      )
    end

    puts "Simple-S3: Upload Completed!"
  end

  def self.invalidate!
    distribution = self.cloudfront_distribution_id
    return if distribution.nil?

    aws_account    = self.s3_access_key
    aws_secret     = self.s3_secret_key

    path = ['/','/*','/**/*']

    date = Time.now.strftime("%a, %d %b %Y %H:%M:%S %Z")
    digest = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), aws_secret, date)).strip
    uri = URI.parse("https://cloudfront.amazonaws.com/2012-07-01/distribution/#{distribution}/invalidation")

    path_xml = ''
    path.each do |p|
      path_xml += '<Path>'+p+'</Path>'
    end

    req = Net::HTTP::Post.new(uri.path)
    req.initialize_http_header({
      'x-amz-date' => date,
      'Content-Type' => 'text/xml',
      'Authorization' => "AWS %s:%s" % [aws_account, digest]
    })

    xml = '<InvalidationBatch xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/">' +
          ' <Paths>' +
          '  <Quantity>' + path.length.to_s + '</Quantity>' + 
          '  <Items>' +
          path_xml + 
          '  </Items>' +
          ' </Paths>' +
          ' <CallerReference>SOMETHING_SPECIAL_' + Time.now.utc.to_i.to_s + '</CallerReference>' +
          '</InvalidationBatch>'
    req.body = xml

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = http.request(req)
    
    # it was successful if response code was a 201
    if res.code == '201'
      puts 'Simple-S3: Invalidation Successful'
    else
      raise res.body.to_s
    end
  end

end
