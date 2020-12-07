# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true #where are we querying something that would
    # require us to put a pw = nil

    after_initialize :ensure_session_token

    attr_reader :password

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return nil unless user && user.is_password?(password)
        user
    end 

    def password=(pw)
        @password = pw #why do we need to create a instance variable for password?
        self.password_digest = BCrypt::Password.create(pw)
    end 

    def reset_session_token!
        self.update!(session_token: self.class.generate_session_token)
        self.session_token
    end 

    def is_password?(pw)
        bcrypt = BCrypt::Password.new(self.password_digest)

        bcrypt.is_password?(pw)
    end 

    private

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end 

    def self.generate_session_token
        SecureRandom::urlsafe_base64
    end 


    has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat




end 
