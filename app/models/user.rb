class User < ActiveRecord::Base
	has_secure_password
	
	def admin?
		self.username=='marioffm81'
	end
end
