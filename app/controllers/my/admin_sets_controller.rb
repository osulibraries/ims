module My
  class AdminSetsController < MyController

    self.search_params_logic += [
        :show_only_admin_sets
    ]

    def index
      super
      @selected_tab = :admin_sets
      @disable_select_all = true
    end

    protected

    def search_action_url *args
      dashboard_admin_sets_url *args
    end

  end
end
