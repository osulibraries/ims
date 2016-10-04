require "./lib/export/export.rb"
module Export
  class ExportAllResources < ExportBase
  
    def export
      Osul::Export::ExportList.all.each_with_index do |item, i|
        puts item.fid
        path = get_path_from_id(item.fid)
        export_path = @fedora_root_url + path + "/fcr:export?format=jcr/xml"
        xml_data = open(export_path).read
        h = {}
        h[:fid] = item.fid
        h[:resource_type] = ""
        h[:content] = xml_data
        begin
          puts "index #{i}"
          Osul::Export::AllItemsExport.create!(JSON.parse(h.to_json))
        rescue
          puts "exception for #{item.fid}"
          next
        end
      end
    end

    private
      def get_path_from_id(id)
        path = id[0..1] + '/' + id[2..3] + '/' + id[4..5] + '/' + id[6..7] + '/' + id
      end
  end 
end
