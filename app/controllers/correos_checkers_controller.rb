class CorreosCheckersController < ApplicationController

  def new
    @correos_checker = CorreosChecker.new
  end

  def create
    @correos_checker = CorreosChecker.new(create_params)

    if @correos_checker.save
      flash[:notice] = "Añadido tracking number"
      redirect_to new_correos_checker_url
    else
      flash[:alert] = @correos_checker.errors.full_messages.first
      render 'new'
    end
  end

  private

  def create_params
    params.require(:correos_checker).permit(:email,:tracking_number)
  end
end