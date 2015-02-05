class CorreosCheckersController < ApplicationController

  def new
    @correos_checker = CorreosChecker.new
  end

  def create
    @correos_checker = CorreosChecker.new(create_params)

    if @correos_checker.save
      flash[:warning] = "Hemos enviado un email a tu dirección de correo, tienes 24 horas para confirmar la subscripción."
      UserMailer.confirm_subscription(@correos_checker).deliver
      redirect_to new_correos_checker_url
    else
      flash.now[:alert] = @correos_checker.errors.full_messages.first
      render 'new'
    end
  end

  def check_tracking_numbers
    Checker.new.async.perform
    render nothing: true, status: 200
  end

  def subscribe
    @correos_checker = CorreosChecker.find_by_token(params[:token])
    if @correos_checker.confirmed
      flash.now[:warning] = "La subscripción ya se encuentra dada de alta."
    else
      @correos_checker.update(confirmed: true)
      flash.now[:success] = "La subscripción acaba de ser dada de alta."
    end
  end

  def unsubscribe
    @correos_checker = CorreosChecker.find_by_token(params[:token])
    if @correos_checker
      @correos_checker.destroy
      flash.now[:success] = "La subscripción ha sido dada de baja del sistema."
    else
      flash.now[:alert] = "No existe esa subscripción en el sistema."
    end
  end

  private

  def create_params
    params.require(:correos_checker).permit(:email,:tracking_number, :description)
  end
end