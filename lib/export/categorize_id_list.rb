require "./lib/export/export.rb"
require "./lib/export/generic_file_export.rb"
module Export
  class CategorizeIdList < ExportBase

    def self.categorize
      starting_point = Osul::Export::CategorizeExportList.count
      Osul::Export::ExportList.offset(starting_point).all.each_with_index do |item, i|
        puts item.fid
        begin
          resource = ActiveFedora::Base.find(item.fid)
          if resource.class.to_s == "GenericFile"
            puts "exporting single gf: #{item.fid}"
            Export::GenericFileExport.new.export_single_gf(item.fid)
          end
        rescue
          puts 'rescued ---'
          next
        end
         puts "index #{i}"
        Osul::Export::CategorizeExportList.create!(fid: item.fid, resource_type: resource.class)
      end
    end
  end
end
