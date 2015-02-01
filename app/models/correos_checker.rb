class CorreosChecker < ActiveRecord::Base
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  validates :tracking_number, presence: true

  scope :unfinished, -> { where('completed_at is NULL') }
  scope :completed, -> { where("completed_at is not NULL and completed_at < '#{2.days.ago}'") }

  def check_tracking_state

    #url = "http://aplicacionesweb.correos.es/localizadorenvios/track.asp?numero=#{tracking_number}"
    #doc = Nokogiri::HTML(open(url))

    randomString = ('a'..'z').to_a.shuffle[0,8].join
    doc = Nokogiri::HTML("<html><body><div><tr class='txtCabeceraTabla'><td>#{randomString}</td></tr></div></body></html>")

    if doc.css('body div').first.to_s.match(/No disponemos de infor/)
      increment_counter :error_count, id
    else
      current_status = doc.css('.txtCabeceraTabla').last.css('td').last.text

      if current_status != status
        updated_attributes = { status: current_status }
        updated_attributes[:completed_at] = Time.now if current_status.include?('Entregado')
        self.class.where(id: id).update_all(updated_attributes)
        self.reload
        UserMailer.status_updated(self).deliver
      end
    end
  end

  def remove_tracking_number
    self.class.destroy(id)
  end

  private
  def downcase_email
  	self.email = email.downcase
  end

end