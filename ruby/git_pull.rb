require 'Pathname'
require 'colorize'

repo = ARGV[0]
work = 'PATH_2_WORK'
open = 'PATH_2_PERSONAL'

if repo == 'work' 
  Pathname.new("#{work}").children.select { |c| c.directory? }.collect { |p| p.to_s }.each do |reponame|
  	Dir.chdir("#{reponame}")
  	puts "Doing git pull on repo:  ".green + reponame.split('/').last.yellow
  	`git pull --rebase`
  end
else
  Pathname.new("#{open}").children.select { |c| c.directory? }.collect { |p| p.to_s }.each do |reponame|
  	Dir.chdir("#{reponame}")
  	puts "Doing git pull on repo:  ".green + reponame.split('/').last.yellow
  	`git pull --rebase`
  end
end
