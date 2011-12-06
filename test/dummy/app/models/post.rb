class Post < ActiveRecord::Base
  include InfinitePage::Scope
end