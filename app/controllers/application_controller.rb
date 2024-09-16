class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  def manifest
    render json: File.read(Rails.root.join("public", "manifest.json")), content_type: "application/json"
  end
end
