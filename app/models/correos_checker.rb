class CorreosChecker < ActiveRecord::Base
  before_create :generate_token
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_TRACKING_NUMBER_REGEX = /\A[\w]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  validates :tracking_number, presence: true, length: { maximum: 50 }, uniqueness: true,
                    format: { with: VALID_TRACKING_NUMBER_REGEX }

  validates :description, length: { maximum: 255 }

  scope :unconfirmed, -> { where("confirmed is FALSE and updated_at < '#{1.days.ago}'") }
  scope :unfinished, -> { where('completed_at is NULL and confirmed is TRUE') }
  scope :completed, -> { where("completed_at < '#{2.days.ago}'") }

  def check_tracking_state

    url = "http://aplicacionesweb.correos.es/localizadorenvios/track.asp?numero=#{tracking_number}"

    begin
      doc = Nokogiri.HTML(open(url))

      if doc.css('body div').first.to_s.match(/No disponemos de infor/)
        if updated_at < 7.days.ago
          unconfirm_tracking_number
          UserMailer.invalid_tracking_number(self).deliver
        end
      else
        current_status = doc.css('span.txtNormal').last
        if current_status.blank?
          puts "html layout has changed?"
        else
          current_status = current_status.text.strip
          if current_status != status
            updated_attributes = { status: current_status }
            updated_attributes[:completed_at] = Time.now if current_status.include?('Entregado')
            self.update_attributes(updated_attributes)
            UserMailer.status_updated(self).deliver
          else
            if updated_at < 30.days.ago
              unconfirm_tracking_number
              UserMailer.complete_time_exceeded(self).deliver
            end
          end
        end
      end
    rescue Exception => e
      puts "Couldn't read \"#{ url }\": #{ e }"
    end
  end

  def unconfirm_tracking_number
    self.update_attribute(:confirmed, false)
  end

  def remove_tracking_number
    self.destroy
  end

  private
  def downcase_email
  	self.email = email.downcase
  end

  def generate_token
    self.token = SecureRandom.hex
  end
end