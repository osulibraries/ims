require "./lib/export/list.rb"
require "./lib/export/categorize_id_list.rb"
require "./lib/export/generic_file_export.rb"
require "./lib/export/export_all_resources.rb"

namespace :export do
  desc "Clear all export data"
  task :clear_all => :environment do
    STDOUT.puts "Are you sure you want to erase everything? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      puts "Start time is:" + Time.now.to_s
      puts "clearing everything..."
      Osul::Export::ExportList.delete_all
      Osul::Export::CategorizeExportList.delete_all
      Osul::Export::ExportGenericFileItem.delete_all
      Osul::Export::AllItemsExport.delete_all
      puts "everything has been cleared"
    else
      STDOUT.puts "Bye!"
    end
  end

  desc "Get list of fedora resource ids and store in DB"
  task :get_resource_id_list => :environment do
    puts "starting fetching ids..."
    start_time = Time.now
    if Rails.env == "production"
      isolate_branch = ["g7/32","g7/33"]
    end
    Export::List.new.fetch_ids (isolate_branch)
    puts "get_resource_id_list task duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
    puts "done fetching ids"
  end

  desc "Categorize fedora ids by associating the resource type (ex: GenericFile or Batch ...) and store in DB"
  task :categorize_id_list => :environment do
    start_time = Time.now
    puts "starting categorizing ids..."
    Export::CategorizeIdList.categorize
    puts "categorize_id_list task duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
    puts "done categorizing ids"
  end
  
  desc "Export All GenericFiles to DB"
  task :export_generic_files => :environment do
    start_time = Time.now
    puts "starting exporting all GenericFiles..."
    Export::GenericFileExport.new.export_all_gfs
    puts "export_generic_files task duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
    puts "done exporting all GenericFiles"
  end
  
  desc "Export All VRA Measurements to DB"
  task :export_vra_measurements => :environment do
    start_time = Time.now
    puts "starting exporting all Measurements..."
    Export::GenericFileExport.new.export_vra_measurements
    puts "export_vra_measurements task duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
    puts "done exporting all Measurements"
  end

 desc "Export All VRA Materials to DB"
  task :export_vra_materials => :environment do
    start_time = Time.now
    puts "starting exporting all Materials..."
    Export::GenericFileExport.new.export_vra_materials
    puts "export_vra_materials task duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
    puts "done exporting all Materials"
  end

  desc "Export All Fedora resources to DB in their xml format"
  task :export_all_resources => :environment do
    start_time = Time.now
    puts "starting exporting all resources..."
    Export::ExportAllResources.new.export
    puts "export_all_resources task duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
    puts "done exporting all resources"
  end


  desc "Migrate everything"
  task :migrate_all => [:clear_all, :get_resource_id_list, :categorize_id_list, :export_generic_files, :export_vra_measurements, :export_vra_materials, :export_all_resources]
end


