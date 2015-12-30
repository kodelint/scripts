# Author: Satyajit Roy
# Date: 12/29/2015
# Purpose: I usually work with load of repos and time to time I need to make sure that I have the latest and the greatest.

require 'Pathname'
require 'colorize'

Pathname.new('/src/repo').children.select { |c| c.directory? }.collect { |p| p.to_s }.each do |reponame|
	Dir.chdir("#{reponame}")
	puts "Doing git pull on repo: ".green + reponame.split('/').last.yellow
	`git pull --rebase`
end

#TODO: Email notification for the updated repos
