class LemondeWorker
	include Sidekiq::Worker
	sidekiq_options retry: 0

	require 'nokogiri'
	require 'csv'

	def perform()

		for i in 1..30
			
			if i.to_s.length == 1
				day_int = "0" + i.to_s
			else 
				day_int = i.to_s
			end
			url = "https://www.lemonde.fr/sitemap/articles/2021-10-#{day_int}.xml"
			puts url
			response = Faraday.get(url)
			xml = Nokogiri::XML(response.body)

			xml.css("url").each_with_index do |item, index|
				url = item.css('loc').text
				title = item.xpath('//news:title')[index].text
				publication_date = item.xpath('//news:publication_date')[index].text

				# we check if it's a premium article
				html = Faraday.get(url)
				content = Nokogiri::HTML(html.body)
				premium = content.at('meta[property="og:article:content_tier"]')['content'] if content.at('meta[property="og:article:content_tier"]').present?

				if content.at('meta[property="og:article:author"]').present?
					author_name = content.at('meta[property="og:article:author"]')['content']

					if Author.exists?(:name => author_name)
						author_id = Author.find_by_name(author_name).id
					else
						new_author = Author.new(name: author_name)
						if new_author.save
							author_id = new_author.id
						end
					end
				end

				Article.create(publication_id: 1, author_id: author_id ||= nil, title: title, url: url, publication_date: publication_date.to_datetime, premium: premium)
			end
		end
	end
end