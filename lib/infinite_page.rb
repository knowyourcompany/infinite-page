module InfinitePage
  class Engine < ::Rails::Engine
    initializer "infinite_page" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, InfinitePage::Scope
      end

      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :include, InfinitePage::CurrentPage
      end
    end
  end

  module Scope
    extend ActiveSupport::Concern

    module ClassMethods
      def page(page, per_page = 50)
        limit(per_page).offset((page - 1) * per_page)
      end
    end
  end

  module CurrentPage
    extend ActiveSupport::Concern

    included { helper_method :current_page }

    def current_page
      page = params[:page].to_i
      page > 0 ? page : 1
    end
  end
end