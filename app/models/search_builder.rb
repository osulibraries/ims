class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include Hydra::AccessControlsEnforcement
  include Hydra::PolicyAwareAccessControlsEnforcement
  include Sufia::SearchBuilder
  include Osul::SearchBuilder
end