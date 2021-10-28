class Article < ApplicationRecord
	belongs_to :publication
	belongs_to :author, optional: true 
end
