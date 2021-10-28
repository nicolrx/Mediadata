Rails.application.routes.draw do
  resources :authors
  resources :publications, param: :slug
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

	root to: "home#index"
	get "number_of_publication_articles_daily/:publication_id", to: "chart#number_of_publication_articles_daily", as: "number_of_publication_articles_daily"
	get "number_of_publication_articles_weekly/:publication_id", to: "chart#number_of_publication_articles_weekly", as: "number_of_publication_articles_weekly"	
	get "pie_premium_articles/:publication_id", to: "chart#pie_premium_articles", as: "pie_premium_articles"
end
