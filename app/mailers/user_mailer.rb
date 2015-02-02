class UserMailer < ActionMailer::Base
  default from: 'noreply@correoscheckerbot.com'

	def status_updated(checker)
      @checker =  checker
      mail to: @checker.email, subject: 'Estado actualizado'
	end
end