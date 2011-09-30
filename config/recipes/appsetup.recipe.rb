# only use this recipe when initializing a server
# this recipe will not be placed into the deploy scheme

namespace :appsetup do
	desc "Install the base system needed to support Race 2.x"
	task :default, :roles => [:web,:app] do
		appsetup.install.aptitude
		appsetup.install.rubygems
		appsetup.install.redis
		appsetup.create_ruby_gem_symbolic_links
		appsetup.install.bundler
	end
	desc "[internal] normalize the ruby and gem commands"
	task :create_ruby_gem_symbolic_links, :roles => [:web,:app] do
		run "ln -nfs /usr/bin/ruby1.8 /user/bin/ruby"
		run "ln -nfs /usr/bin/gem1.8 /user/bin/gem"
	end
	namespace :install do
		namespace :aptitude do
			desc "Install all the needed Debian system libraries and commands"
			task :default, :roles => [:web] do
				appsetup.install.aptitude.sudo
				appsetup.install.aptitude.gcc
				appsetup.install.aptitude.make
				appsetup.install.aptitude.git
				appsetup.install.aptitude.mysql
				appsetup.install.aptitude.libmysqlclient15
				appsetup.install.aptitude.ruby
				appsetup.install.aptitude.libsqlite
				appsetup.install.aptitude.imagemagick
				appsetup.install.aptitude.librmagick
				appsetup.install.aptitude.libmagick9
			end
			desc "[internal] Install Sudo"
			task :sudo, :roles => [:web] do
				run "aptitude install sudo"
			end
			desc "[internal] Install GCC"
			task :gcc, :roles => [:web] do
				run "aptitude install gcc"
			end
			desc "[internal] Install make"
			task :make, :roles => [:web] do
				run "aptitude install make"
			end
			desc "[internal] Install GIT"
			task :git, :roles => [:web] do
				run "aptitude install git-core"
			end
			desc "[internal] Install mysql-server"
			task :mysql, :roles => [:web] do
				run "aptitude install mysql-server"
			end
			desc "[internal] Install libmysqlclient15-dev"
			task :libmysqlclient15, :roles => [:web] do
				run "aptitude install libmysqlclient15-dev"
			end
			desc "[internal] Install Ruby 1.8"
			task :ruby, :roles => [:web] do
				run "aptitude install ruby1.8-dev"
			end
			desc "[internal] Install libsqlite3-dev"
			task :libsqlite, :roles => [:web] do
				run "aptitude install libsqlite3-dev"
			end
			desc "[internal] Install ImageMagick"
			task :imagemagick, :roles => [:web] do
				run "aptitude install imagemagick"
			end
			desc "[internal] Install Ruby libraries for RMagick"
			task :librmagick, :roles => [:web] do
				run "aptitude install librmagick-ruby"
			end
			desc "[internal] Install additional libraries for the RMagick gem"
			task :libmagick9, :roles => [:web] do
				run "aptitude install libmagick9-dev"
			end
		end
		namespace :bundler do
			desc "Install Ruby Bundler with gem"
			task :default, :roles => [:web] do
				appsetup.install.bundler.setup
				run "cd #{current_path} && bundler install"
			end
			desc "[internal] Run the setup install script"
			task :setup, :roles => [:web] do
				run "gem install bundler"
			end
		end
		namespace :rubygems do
			desc "Install rubygems from source"
			task :default, :roles => [:web] do
				appsetup.install.rubygems.create_srouce_dir
				appsetup.install.rubygems.download_source
				appsetup.install.rubygems.setup
			end
			desc "[internal] Create SRC folder"
			task :create_srouce_dir, :roles => [:web] do
				run "mkdir -p #{sourcedir}"
			end
			desc "[internal] Download Rubygems' source"
			task :download_source, :roles => [:web] do
				run "cd #{sourcedir} && wget -q #{rubygemsource} && tar -xzf #{sourcedir}/rubygems-#{rubygemversion}.tgz"
			end
			desc "[internal] Run the setup install script"
			task :setup, :roles => [:web] do
				run "ruby1.8 #{sourcedir}/rubygems-#{rubygemversion}/setup.rb"
			end
		end
		namespace :redis do
			desc "Install Redis from source"
			task :default, :roles => [:web] do
				appsetup.install.redis.create_srouce_dir
				appsetup.install.redis.download_source
				appsetup.install.redis.setup
			end
			desc "[internal] Create SRC folder if it does not exist"
			task :create_srouce_dir, :roles => [:web] do
				run "mkdir -p #{sourcedir}"
			end
			desc "[internal] Download Redis' source"
			task :download_source, :roles => [:web] do
				run "cd #{sourcedir} && wget -q #{redissource} && tar -xzf #{sourcedir}/redis-#{redisversion}.tar.gz"
			end
			desc "[internal] Run the setup install script"
			task :setup, :roles => [:web] do
				run "cd #{sourcedir}/rubygems-#{redisversion} && make"
			end
		end
	end
end
