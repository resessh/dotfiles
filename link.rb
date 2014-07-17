#!/home/resessh/.rbenv/shims/ruby

require 'fileutils'

ignoreFiles = [".git", ".", "..", ".gitignore", "README.md", "link.rb"]
localFiles = [".zshrc_local", ".tmux.local.conf"]


currentDir = Dir::getwd
homeDir = File::dirname(currentDir)

dirFiles = Dir::entries(currentDir)
homedirFiles = Dir::entries(homeDir)

ignoreFiles = ignoreFiles + localFiles
dirFiles.each do |dirfile|
	if ignoreFiles.include?(dirfile)
		puts dirfile+" is ignored."
	else
		if homedirFiles.include?(dirfile)
			puts dirfile+" is already exists."
		else
			puts "make symbolic link of #{dirfile}." 
			File::symlink( currentDir+"/"+dirfile, homeDir+"/"+dirfile)
		end
	end
end

localFiles.each do |localfile|
	if homedirFiles.include?(localfile)
		puts localfile+" is already exists."
	else
		puts "make copy of #{localfile}."
		puts "#{currentDir}/#{localfile}"
		FileUtils.cp( currentDir+"/"+localfile, homeDir+"/"+localfile)
	end
end