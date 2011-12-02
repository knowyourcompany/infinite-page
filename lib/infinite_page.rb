module InfinitePage
  class Engine < ::Rails::Engine
    initializer "infinite_page" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, InfinitePage::Scope
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
end