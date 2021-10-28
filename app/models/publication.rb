class Publication < ApplicationRecord
	before_create :set_slug, unless: :slug?

	has_many :articles

	def to_param
		slug
	end

	def set_slug
		self.slug = self.name.parameterize
	end
end
