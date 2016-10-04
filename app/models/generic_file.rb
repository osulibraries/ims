# See https://groups.google.com/forum/#!searchin/hydra-tech/sufia$20add$20fields/hydra-tech/xm60TrH8UO8/D4Xr-FM5gksJ for how to extend Generic File
class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include Osul::GenericFile::Metadata
  include Osul::GenericFile::Content
  include Osul::AttributeUniqueness

# TODO: refactor this area. Needs broken down.
  belongs_to_admin_collection
  accepts_nested_attributes_for :materials, allow_destroy: true
  accepts_nested_attributes_for :measurements, allow_destroy: true

  alias_method :materials_attributes_without_uniqueness=, :materials_attributes=
  alias_method :materials_attributes=, :attributes_with_uniqueness=

  alias_method :measurements_attributes_without_uniqueness=, :measurements_attributes=
  alias_method :measurements_attributes=, :attributes_with_uniqueness=

  belongs_to :admin_policy, predicate: ActiveFedora::RDF::ProjectHydra.isGovernedBy, class_name: "Osul::AdminPolicy"

  before_save :check_visibility
  before_save :inherit_admin_policy
  before_save :watermark
  after_save :track_generic_file


  # This is an override
  def create_derivatives
    if transformation_schemes.present?
      transformation_schemes.each do |transform_scheme|
        if transform_scheme.instance_of?(Proc)
          transform_scheme.call(self)
        else
          send(transform_scheme)
        end
      end
      #This is the line we're adding and its for the creation of watermarks upon ingest or updated file
      Osul::Watermark.new(self, 'content', nil).create_derivative if self.requires_watermark?
    else
      logger.warn "`create_derivatives' was called on an instance of #{self.class}, but no derivatives have been requested"
    end
  end

  def track_generic_file
    Osul::Export::ChangeTracker.create!(fid: self.id, object_type: self.class, user_id: self.depositor)
  end

  def watermark
    unless low_resolution.has_content?
      Osul::Watermark.new(self, 'content', nil).create_derivative
    end
  end
  def requires_watermark?
    self.unit == "BillyIrelandCartoonLibraryMuseum"
  end

  def build_credit_line
    credit_line_components.join(self.get_join_symbol)
  end
  def get_join_symbol
    char = ", "
    char = "; " if self.part_of.find{|part| (part.match /,/).present?}
    return char
  end
  def credit_line_components
    ((part_of.empty?) ? parent_credit_line_components : self.part_of + parent_credit_line_components )
  end
  def parent_credit_line_components
    ["The Ohio State University " + unit_group.name ]
  end
  def unit_group
    Osul::Group.find_by_key(unit)
  end

  def check_visibility
    if self.visibility && self.collection
      self.visibility = (self.visibility_greater_than_parent?) ? self.collection.visibility : self.visibility
    end
  end

  def visibility_greater_than_parent?
    score = {"restricted" => 1, "authenticated" => 2, "open" => 3}
    score[visibility] > score[self.collection.visibility]
  end

  def has_image?
    uri = URI.parse self.content.uri
    http = Net::HTTP.new uri.host, uri.port
    request = Net::HTTP::Get.new uri.request_uri
    request.basic_auth 'fedoraAdmin', 'fedoraAdmin'
    response = http.request request
    response.code == "200"
  end

  def inherit_admin_policy
    if self.collection
      self.admin_policy = self.collection.admin_policy
      self.unit = self.collection.unit
    end
  end

  # Append latest version tag to id  (Used for riiif cache busting)
  def latest_version_id
    #in show view the content object contains solr info, so does not have version info - In that case we're going to refetch the object from fedora
    if content.class == FileContentDatastream
      version_content = content
    else
      g = GenericFile.find id
      version_content = g.content
    end

    if version_content.respond_to?(:latest_version)
      loris_id = get_full_path_id + '-' + (version_content.latest_version.try(:label) || "")
    else
      loris_id = get_full_path_id
    end

    #For now we still need to tell it wether to get original of watermarked version
    if requires_watermark?
      loris_id + '-' + 'low_resolution'
    else
      loris_id + '-' + 'content'
    end
  end

  #Create fedora path id from generic file id (ie. g7364f562 => /g7/36/4f/56/g7364f562)
  def get_full_path_id
    full_path_id = self.id[0..1] + '/' + self.id[2..3] + '/' + self.id[4..5] + '/' + self.id[6..7] + '/' + self.id
  end

end
