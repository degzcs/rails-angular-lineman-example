namespace :db do
  namespace :seed do
    desc "Allows to load a custom seed file localized inside db/ like this: rake db:seed:custom_seed_file"
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern    
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end