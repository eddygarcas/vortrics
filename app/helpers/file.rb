class File
	def self.create_rsa_file key_string = nil, file_name = 'rsakey.pem'
		return nil unless key_string.present?
		outh_file = File.new(file_name, 'w+')
		outh_file.write(key_string)
		outh_file.close
		outh_file
	end
end