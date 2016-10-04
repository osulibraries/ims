require "./lib/export/export.rb"
module Export
  class List < ExportBase
  
    # Fetches the Fedora 4 IDs for all the objects 
    # Params:
    # *isolate_branches* (optional) - Used to identify specific branches as 'heavy', 
    #   therefore needing their own subprocessing (ex:["g7/33", "g7/32", "ab"]) - Maximum two level deep
    def fetch_ids(isolate_branches=nil)
      all_branches = get_list_of_branches(isolate_branches)
      all_ids =[]
      starting_point = get_branch_starting_point(all_branches)
      all_branches -= all_branches.first(starting_point + 1)
      all_branches.each do |root_url|
        all_ids += fetch_ids_from_root_url(root_url)
      end
    end

    # Fetches all the Fedora 4 descendant URIs for a given URI.
    # Stolen from: https://github.com/projecthydra/active_fedora/blob/master/lib/active_fedora/indexing.rb#L72-L79
    def descendant_uris(uri)
      resource = Ldp::Resource::RdfSource.new(ActiveFedora.fedora.connection, uri)
      #Since we are using permutations of Uris that might not exist, we have to check for Ldp::NoneClass being returned as well
      if (resource.head.class == Ldp::NoneClass or !Ldp::Response.rdf_source?(resource.head))
        return []
      end
      # we need to catch and rescue some of these resources that may have been corrupted
      begin
        immediate_descendant_uris = resource.graph.query(predicate: ::RDF::Vocab::LDP.contains).map { |descendant| descendant.object.to_s }
      rescue
        puts "this last id '#{uri}' is throwing error"
        immediate_descendant_uris = [] 
      end
      all_descendants_uris = [uri]

      # Recursively get descendents
      immediate_descendant_uris.each do |descendant_uri|
        all_descendants_uris += descendant_uris(descendant_uri)
      end
      all_descendants_uris
    end


  private
    #build array of all permutations of two alphanumeric characters 
    #returns ["00"..."zz"]
    def all_permutations_array
      arr = (0...36).map{ |i| i.to_s 36}
      arr2 = (0...36).map{ |i| i.to_s 36}
      all_arr = []
      arr.each do |first|
        arr2.each do |second|
          all_arr << first+second
        end
      end
      all_arr
    end

    def fetch_ids_from_root_url(root_url)
      all_ids = []
      puts "in branch #{root_url}"
      start_time = Time.now
      descendants = descendant_uris(root_url)

      descendants.shift # Discard the root uri
      if descendants.blank?
        puts "----- tree is empty -----"
      else
        puts "found #{descendants.count} item(s)"
        descendant_ids = descendants.map { |uri| uri.split("/").last }
        all_ids += descendant_ids
      end
      unless descendant_ids.nil?
        puts 'storing ids'
        descendant_ids.each_with_index do |id, i|
          puts "storing id #{i}"
          Osul::Export::ExportList.create!(fid: id)
        end
      end
      puts "Duration: " + Time.at(Time.now - start_time).utc.strftime("%H:%M:%S")
      
      all_ids
    end

    # Get all the individual branches that will be queried seperately and store them in array
    def get_list_of_branches(isolate_branches=nil)
      permutations = all_permutations_array;nil
      first_levels = []
      unless  isolate_branches.nil?
        isolate_branches.each do |ib|
          first_levels << ib.split("/").first
        end
      end

      first_levels.uniq!
      permutations -= first_levels;nil
      all_branches = []
      permutations.each do |node|
        uri = @fedora_root_url + node + '/'
        all_branches << uri;nil
      end;nil

      #Take care of isolated branches

      first_levels.each do |first_level|
        second_levels = []
        root_url = @fedora_root_url + first_level + "/"
        permutations = all_permutations_array;nil
        isolate_branches.each do |ib|
          if first_level == ib.split("/").first
            second_levels << ib.split("/").second
          end
        end
        second_levels.uniq!
        permutations -= second_levels

        permutations.each do |node|
          uri = root_url + node + '/'
          all_branches << uri
        end
        second_levels.each do |second_level|
          permutations = all_permutations_array;nil
          root_url =  @fedora_root_url + first_level + '/' + second_level + '/'
          permutations.each do |node|
            uri = root_url + node + '/'
            all_branches << uri
          end
        end
      end

      all_branches
    end

    def get_branch_starting_point(all_branches)
      id = Osul::Export::ExportList.last.try(:fid)
      return -1 if id.nil?
      
      root_level_url = @fedora_root_url + id[0..1] + '/' 
      first_level_url = @fedora_root_url + id[0..1] + '/' + id[2..3] +'/' 
      second_level_url = @fedora_root_url + id[0..1] + '/' + id[2..3] +'/' + id[4..5] +'/'

      unless (index = all_branches.index(second_level_url)).nil?
        return index
      end
      unless (index = all_branches.index(first_level_url)).nil?
        return index
      end
      unless (index = all_branches.index(root_level_url)).nil?
        return index
      end
      return -1
    end
  end
end
