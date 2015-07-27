class User < ActiveRecord::Base
	has_secure_password
	has_many :tipps
	has_many :results
	
	def admin?
		self.username=='marioffm81' || self.role
	end
end
