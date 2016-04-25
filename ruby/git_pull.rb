require 'Pathname'
require 'colorize'

# I worte this because I wanted to pull all update first things in morning 

Pathname.new('REPO_PATH').children.select { |c| c.directory? }.collect { |p| p.to_s }.each do |reponame|
	Dir.chdir("#{reponame}")
	puts "Doing git pull on repo:  ".green + reponame.split('/').last.yellow
	`git pull --rebase`
end
