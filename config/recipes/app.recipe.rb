before "deploy:migrate", "app:symlinks:db"
after  "deploy:symlink", "app:symlinks:all"
# possibly reinstate this at a later date
#after  "deploy:symlink", "app:deploy:remove_gems"

namespace :app do
	namespace :symlinks do
		desc "create ALL symlinks"
		task :all, :roles => [:app] do
			transaction do
				app.symlinks.db
				app.symlinks.imports
				app.symlinks.storage
				app.symlinks.storage_public
			end
		end
		desc "create the database YAML symlink"
		task :db, :roles => [:app] do
			run "ln -nfs #{shared_path}/database.yml #{current_path}/config/database.yml"
		end
		desc "create the imports symlink"
		task :imports, :roles => [:app] do
			# remove the versioned symlink to the imports DIR
			run "rm -rf #{current_path}/imports"
			run "ln -nfs #{shared_path}/imports #{current_path}/imports"
		end
		desc "create the storage symlink"
		task :storage, :roles => [:app] do
			run "ln -nfs #{shared_path}/storage #{current_path}/storage"
		end
		desc "create the public storage symlink"
		task :storage_public, :roles => [:app] do
			run "ln -nfs #{shared_path}/storage #{current_path}/public/images/storage"
		end
	end
	namespace :deploy do
		# this is only to be used until the local gem issue is resolved.
		desc ""
		task :remove_gems do
			run "rm -rf #{current_path}/gems"
		end
	end
	namespace :setup do
		desc "copy the example DB yaml file over to the shared directory"
		task :database_yml, :roles => [:app] do
			run "cp #{current_path}/config/database.example #{shared_path}/database.yml"
			run "ln -nfs #{shared_path}/database.yml #{current_path}/config/database.yml"
		end
		desc "run the automigrate rake command"
		task :automigrate, :roles => [:app] do
			run "cd #{current_path} && rake db:automigrate"
		end
		desc "run the autoupgrade rake command (.i.e Perform non destructive automigration)"
		task :autoupgrade, :roles => [:app] do
			run "cd #{current_path} && rake db:autoupgrade"
		end
	end
end
namespace :deploy do
	desc "Restart Application"
	task :restart, :roles => :app do
		run "touch #{current_path}/tmp/restart.txt"
	end
end
namespace :passenger do
	desc "Analyze Phusion Passenger's and Apache's real memory usage."
	task :memory_stats, :roles => :app do
		sudo "passenger-memory-stats"
	end
	desc "Inspect Phusion Passenger's internal status"
	task :status, :roles => :app do
		sudo "passenger-status"
	end
end
