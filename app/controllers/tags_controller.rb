class TagsController < ApplicationController
  respond_to :json
  def index
    @tags = ActsAsTaggableOn::Tag.named_like(params[:q] ||= "").page(params[:page]).per(params[:limit])
    respond_with @tags
  end
end
