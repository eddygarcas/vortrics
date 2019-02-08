class File
	def self.create_rsa_file key_string, file_name = 'rsakey.pem'
		outh_file = File.new(file_name, 'w+')
		outh_file.write(key_string)
		outh_file.close
		outh_file
	end
end