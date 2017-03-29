require 'Pathname'
require 'colorize'

repo = ARGV[0]
work = 'PATH_2_WORK'
personal = 'PATH_2_PERSONAL'

if repo == 'work' 
  Pathname.new("#{work}").children.select { |c| c.directory? }.collect { |p| p.to_s }.each do |reponame|
  	Dir.chdir("#{reponame}")
  	puts "Doing git pull on repo:  ".green + reponame.split('/').last.yellow
  	`git pull --rebase`
  end
elsif repo == 'personal'
  Pathname.new("#{personal}").children.select { |c| c.directory? }.collect { |p| p.to_s }.each do |reponame|
  	Dir.chdir("#{reponame}")
  	puts "Doing git pull on repo:  ".green + reponame.split('/').last.yellow
  	`git pull --rebase`
	end
else
	puts "You got the wrong argument, only 'work' or 'personal' is allowed"
end
