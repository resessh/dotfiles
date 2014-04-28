#!/home/resessh/.rbenv/shims/ruby

ignoreFiles = [".git", ".", "..", ".gitignore", "README.rb", "link.rb"]

currentDir = Dir::getwd
homeDir = File::dirname(currentDir)


dirFiles = Dir::entries(currentDir)
homedirFiles = Dir::entries(homeDir)
dirFiles.each do |dirfile|
	if ignoreFiles.include?(dirfile)
		puts dirfile+" is ignored."
	else
		if homedirFiles.include?(dirfile)
			puts dirfile+" is already exists."
		else
			puts "make symbolic link of "+dirfile+"." 
			File::symlink( currentDir+"/"+dirfile, homeDir+"/"+dirfile)
		end
	end
end