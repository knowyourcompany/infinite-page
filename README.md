# Infinite scrolling and pagination for Rails 3.1+

**Requirements:**

* jQuery
* Underscore.js
* CoffeeScript
* Rails 3.1+

## Installing

Gemfile

```ruby
gem 'infinite_page', '~> 0.4.0'
```

app/assets/javascripts/application.js.coffee

```coffeescript
#= require infinite_page

$(document).ready ->
  $('[data-behavior~=infinite_page]').infinitePage()
```

## Using

Add the infinite_page behavior to an html element that contains the records you want to paginate. As you scroll and approach the bottom of the page, infinite_page will make an ajax request for the next page and the results will be appended to the container. This will continue until an empty response is returned.

```rhtml
<!-- app/views/posts/index.html.erb -->
<section data-behavior="infinite_page">
  <%= render @posts %>
</section>
```

```ruby
class Post < ActiveRecord::Base
  include InfinitePage::Scope
end

class PostsController < ApplicationController
  def index
    @posts = @project.posts.page(current_page)

    respond_to do |format|
      format.js { render partial: @posts }
      format.html
    end
  end
end
```

Include InfinitePage::Scope in your models to gain a `page` scope. The first argument is the page number and the second optional argument is the number of records per page (defaults to 50).

Also provided is a `current_page` helper method that returns the current page number from `params[:page]` as an integer (defaults to 1).