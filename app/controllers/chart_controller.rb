class ChartController < ApplicationController

	def number_of_publication_articles_daily
		publication = Publication.includes(:articles).find(params[:publication_id])
    render json: publication.articles.group(:premium).group_by_day(:publication_date).count.chart_json
  end	
	
	def number_of_publication_articles_weekly
		publication = Publication.includes(:articles).find(params[:publication_id])
    render json: publication.articles.group(:premium).group_by_week(:publication_date).count.chart_json
  end	
	
	def pie_premium_articles
		publication = Publication.includes(:articles).find(params[:publication_id])
		free = publication.articles.where(premium: "free")
		premium = publication.articles.where(premium: "locked")
		free_percentage = publication.articles.size / free.size 
		premium_percentage = publication.articles.size / premium.size 

		free_percentage = (free.size.to_f / publication.articles.size.to_f)  * 100
		premium_percentage = (premium.size.to_f  / publication.articles.size.to_f) * 100

		json = {gratuit: free_percentage.round(1), payant: premium_percentage.round(1)}.to_json
    render json: json
	end

end
