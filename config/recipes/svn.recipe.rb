def colorize(text, color_code); "#{color_code}#{text}\033[0m"; end
def red(text); colorize(text, "\033[1;31m"); end
def green(text); colorize(text, "\033[1;32m"); end

namespace :svn do
	desc "update the current release via SVN UPDATE"
	task :update_current, :roles => [:web] do
		run "cd #{current_path} && svn up --username #{scm_username} --password #{scm_password} --no-auth-cache"
		svn.update_revision_file
	end
	desc "update the revision number in the REVISION file"
	task :update_revision_file do
		run "cd #{current_path} && unlink REVISION && svn info . | grep ^Revision | awk '{print $2}' > REVISION"
	end
end
