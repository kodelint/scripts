#!/usr/bin/env ruby

git_bundles = [
  "https://github.com/Lokaltog/vim-distinguished.git",
  "https://github.com/chrisbra/color_highlight.git",
  "https://github.com/itchyny/lightline.vim",
  "https://github.com/morhetz/gruvbox",
  "https://github.com/xsunsmile/showmarks.git",
  "https://github.com/chriskempson/base16-vim",
  "https://github.com/godlygeek/csapprox.git",
  "https://github.com/gregsexton/gitv",
  "https://github.com/mattn/gist-vim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-git",
  "https://github.com/sheerun/vim-polyglot",
  "https://github.com/garbas/vim-snipmate.git",
  "https://github.com/honza/vim-snippets",
  "https://github.com/jtratner/vim-flavored-markdown.git",
  "https://github.com/scrooloose/syntastic.git",
  "https://github.com/nelstrom/vim-markdown-preview",
  "https://github.com/skwp/vim-html-escape",
  "https://github.com/jistr/vim-nerdtree-tabs.git",
  "https://github.com/scrooloose/nerdtree.git",
  "https://github.com/kien/ctrlp.vim",
  "https://github.com/xolox/vim-misc",
  "https://github.com/xolox/vim-session",
  "https://github.com/ecomba/vim-ruby-refactoring",
  "https://github.com/tpope/vim-rails.git",
  "https://github.com/tpope/vim-rake.git",
  "https://github.com/tpope/vim-rvm.git",
  "https://github.com/vim-ruby/vim-ruby.git",
  "https://github.com/Keithbsmiley/rspec.vim",
  "https://github.com/skwp/vim-iterm-rspec",
  "https://github.com/skwp/vim-spec-finder",
  "https://github.com/ck3g/vim-change-hash-syntax",
  "https://github.com/tpope/vim-r",
  "https://github.com/justinmk/vim-sneak",
  "https://github.com/rking/ag.vim",
  "https://github.com/vim-scripts/IndexedSearch",
  "https://github.com/nelstrom/vim-visual-star-search",
  "https://github.com/skwp/greplace.vim",
  "https://github.com/Lokaltog/vim-easymotion",
  "https://github.com/austintaylor/vim-indentobject",
  "https://github.com/bootleq/vim-textobj-rubysymbol",
  "https://github.com/coderifous/textobj-word-column.vim",
  "https://github.com/kana/vim-textobj-datetime",
  "https://github.com/kana/vim-textobj-entire",
  "https://github.com/kana/vim-textobj-function",
  "https://github.com/kana/vim-textobj-user",
  "https://github.com/lucapette/vim-textobj-underscore",
  "https://github.com/nathanaelkane/vim-indent-guides",
  "https://github.com/nelstrom/vim-textobj-rubyblock",
  "https://github.com/vim-scripts/argtextobj.vim",
  "https://github.com/AndrewRadev/splitjoin.vim",
  "https://github.com/Raimondi/delimitMate",
  "https://github.com/briandoll/change-inside-surroundings.vim.git",
  "https://github.com/vim-scripts/camelcasemotion.git",
  "https://github.com/vim-scripts/matchit.zip.git",
  "https://github.com/kristijanhusak/vim-multiple-cursors",
  "https://github.com/Keithbsmiley/investigate.vim",
  "https://github.com/chrisbra/NrrwRgn",
  "https://github.com/MarcWeber/vim-addon-mw-utils.git",
  "https://github.com/bogado/file-line.git",
  "https://github.com/mattn/webapi-vim.git",
  "https://github.com/sjl/gundo.vim",
  "https://github.com/skwp/YankRing.vim",
  "https://github.com/tomtom/tlib_vim.git",
  "https://github.com/tpope/vim-abolish",
  "https://github.com/tpope/vim-endwise.git",
  "https://github.com/tpope/vim-ragtag",
  "https://github.com/tpope/vim-repeat.git",
  "https://github.com/tpope/vim-surround.git",
  "https://github.com/tpope/vim-unimpaired",
  "https://github.com/vim-scripts/AnsiEsc.vim.git",
  "https://github.com/vim-scripts/AutoTag.git",
  "https://github.com/vim-scripts/lastpos.vim",
  "https://github.com/vim-scripts/sudo.vim",
  "https://github.com/goldfeld/ctrlr.vim"
]

require 'fileutils'
require 'open-uri'

bundles_dir = File.join(File.dirname(__FILE__), "bundle")

FileUtils.cd(bundles_dir)

puts "trashing everything (lookout!)"
Dir["*"].each {|d| FileUtils.rm_rf d }

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end
