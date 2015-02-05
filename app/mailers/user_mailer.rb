class UserMailer < ActionMailer::Base
  default from: 'noreply@correoscheckerbot.com'
  layout 'mailer_default'

	def confirm_subscription(checker)
      @checker =  checker
      mail to: @checker.email, subject: "Por favor, confirma tu subscripción a #{@checker.tracking_number}"
	end

	def status_updated(checker)
      @checker =  checker
      mail to: @checker.email, subject: 'Estado actualizado'
	end

  def invalid_tracking_number(checker)
      @checker =  checker
      mail to: @checker.email, subject: 'Número de seguimiento inválido'
  end

  def complete_time_exceeded(checker)
      @checker =  checker
      mail to: @checker.email, subject: 'Tiempo máximo de completado excedido'
  end
end