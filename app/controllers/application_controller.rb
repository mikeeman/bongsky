class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :show_flash

  private

  def show_flash
    flash[:notice] = "Message received! We will get back to you shortly." if request.path == '/pages/contact/#sent'
  end
end
