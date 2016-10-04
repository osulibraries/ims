class MySearchBuilder < Blacklight::SearchBuilder
  include Sufia::MySearchBuilderBehavior
  include Hydra::PolicyAwareAccessControlsEnforcement
  include Osul::SearchBuilder
end