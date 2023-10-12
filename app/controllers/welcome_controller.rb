class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Curso ruby on Rails"
    @meu_nome = params[:nome]
    @curso = params[:curso]
  end
end
