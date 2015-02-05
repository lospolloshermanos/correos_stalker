class UserMailer < ActionMailer::Base
  default from: 'noreply@correoscheckerbot.com'
  layout 'mailer_default'

	def confirm_subscription(checker)
      @checker =  checker
      mail to: @checker.email, subject: 'Por Favor, Confirma Tu Suscripción'
	end

	def status_updated(checker)
      @checker =  checker
      mail to: @checker.email, subject: 'Estado Actualizado'
	end

  def invalid_tracking_number(checker)
      @checker =  checker
      mail to: @checker.email, subject: 'Número De Seguimiento Inválido'
  end

  def complete_time_exceeded(checker)
      @checker =  checker
      mail to: @checker.email, subject: 'Tiempo Máximo De Completado Excedido'
  end
end