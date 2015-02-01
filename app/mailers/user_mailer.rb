class UserMailer < ActionMailer::Base
  default from: 'checkerbot@chekerbotteam.com'

	def status_updated(checker)
    @checker =  checker
    mail to: @checker.email, subjet: 'Estado actualizado'
	end
end