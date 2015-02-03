class CorreosChecker < ActiveRecord::Base
  before_create :add_unsubscribe_hash
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  validates :tracking_number, presence: true

  scope :unfinished, -> { where('completed_at is NULL') }
  scope :completed, -> { where("completed_at is not NULL and completed_at < '#{2.days.ago}'") }

  def check_tracking_state

    url = "http://aplicacionesweb.correos.es/localizadorenvios/track.asp?numero=#{tracking_number}"

    begin
      doc = Nokogiri.HTML(open(url))

      #debug#
      #tempStatus = "#{Time.now.to_s}#{Time.now.to_s}"
      #tempStatus = "No disponemos de infor"
      #tempStatus = "Entregado"
      #doc = Nokogiri::HTML("<html><body><div><tr class='txtCabeceraTabla'><td>#{tempStatus}</td></tr></div></body></html>")
      #######

      if doc.css('body div').first.to_s.match(/No disponemos de infor/)
        remove_tracking_number if created_at < 5.days.ago
      else
        current_status = doc.css('span.txtNormal').last
        if current_status.blank?
          puts "html layout has changed?"
        else
          current_status = current_status.text.strip
          if current_status != status
            updated_attributes = { status: current_status }
            updated_attributes[:completed_at] = Time.now if current_status.include?('Entregado')
            self.class.where(id: id).update_all(updated_attributes)
            self.reload
            UserMailer.status_updated(self).deliver
          end
        end
      end
    rescue Exception => e
      puts "Couldn't read \"#{ url }\": #{ e }"
    end
  end

  def remove_tracking_number
    self.class.destroy(id)
  end

  private
  def downcase_email
  	self.email = email.downcase
  end

  def add_unsubscribe_hash
    self.unsubscribe_hash = SecureRandom.hex
  end
end