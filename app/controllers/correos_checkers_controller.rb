class CorreosCheckersController < ApplicationController

  def new
    @correos_checker = CorreosChecker.new
  end

  def create
    @correos_checker = CorreosChecker.new(create_params)

    if @correos_checker.save
      flash[:success] = "Número de seguimiento añadido al sistema."
      redirect_to new_correos_checker_url
    else
      flash[:alert] = @correos_checker.errors.full_messages.first
      render 'new'
    end
  end

  def check_tracking_numbers
    Checker.new.async.perform
    render nothing: true, status: 200
  end

  def unsubscribe
    @correos_checker = CorreosChecker.find_by_unsubscribe_hash(params[:unsubscribe_hash])
    @correos_checker.destroy
  end

  private

  def create_params
    params.require(:correos_checker).permit(:email,:tracking_number)
  end
end