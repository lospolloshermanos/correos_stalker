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
end