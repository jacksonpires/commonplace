require 'lib/commonplace'
require 'rubygems'
require 'sinatra'
require 'erb'
require 'yaml'

class CommonplaceServer < Sinatra::Base	
	# move these to a config?
	config = YAML::load(File.open("config/commonplace.yml"))
	set :sitename, config['sitename']
	set :dir, config['wikidir']
	
	before do
		@wiki = Commonplace.new(options.dir)
	end
	
	# show the homepage
	get '/' do
		show('home')
	end
	
	get '/special/list' do
		@name = "Known pages"
		@pages = @wiki.list
		erb :list
	end

	# show everything else
	get '/*' do
		show(params[:splat].first)
	end

	# returns a given page (or file) inside our repository
	def show(name)
		if !@wiki.valid?
			# Should probably show a message saying the directory isn't configured correctly
			"Directory not found"
		else
			if page = @wiki.page(name)
				@name = page.name
				@content = page.content
				erb :show
			else
				#halt 404
				"Page not found"
			end
		end
	end
end