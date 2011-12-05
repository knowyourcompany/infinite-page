class PostsController < ActionController::Base
  def index
    @posts = Post.page(current_page, 2)

    respond_to do |format|
      format.js { render partial: @posts }
      format.html
    end
  end
end
