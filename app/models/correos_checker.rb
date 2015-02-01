class CorreosChecker < ActiveRecord::Base
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :tracking_number, presence: true

  scope :unfinished, -> { where('completed_at is NULL') }

  def check_tracking_state
    url = "http://aplicacionesweb.correos.es/localizadorenvios/track.asp?numero=#{tracking_number}"
    doc = Nokogiri::HTML(open(url))

    if doc.css('body div').first.to_s.match(/No disponemos de infor/)
      increment_counter :error_count, id
    else
      current_status = doc.css('.txtCabeceraTabla').last.css('td').last.text
      if current_status != status
        update_column :status, current_status
        UserMailer.status_updated(self).deliver
      end
    end
  end

  private
  def downcase_email
  	self.email = email.downcase
  end

end