class PublicationsController < ApplicationController
  before_action :set_publication, only: %i[ show edit update destroy ]

  # GET /publications or /publications.json
  def index
    @publications = Publication.all
  end

  # GET /publications/1 or /publications/1.json
  def show
    @articles_published = @publication.articles

		average_articles_published_array = @articles_published.group_by_day(:publication_date).count
		
		average_free_articles_published_array = @articles_published.where(premium: "free").group_by_day(:publication_date).count	
		
		average_premium_articles_published_array = @articles_published.where(premium: "locked").group_by_day(:publication_date).count

		@average_articles_published = average_articles_published_array.map { |day| day[1] }.inject{ |sum, el| sum + el }.to_f / average_articles_published_array.size
		
		@average_free_articles_published = average_free_articles_published_array.map { |day| day[1] }.inject{ |sum, el| sum + el }.to_f / average_free_articles_published_array.size		
		
		@average_premium_articles_published = average_premium_articles_published_array.map { |day| day[1] }.inject{ |sum, el| sum + el }.to_f / average_premium_articles_published_array.size

		average_articles_published_array_weekly = @articles_published.group_by_week(:publication_date).count
		
		average_free_articles_published_array_weekly = @articles_published.where(premium: "free").group_by_week(:publication_date).count	
		
		average_premium_articles_published_array_weekly = @articles_published.where(premium: "locked").group_by_week(:publication_date).count

		@average_articles_published_weekly = average_articles_published_array_weekly.map { |day| day[1] }.inject{ |sum, el| sum + el }.to_f / average_articles_published_array_weekly.size
		
		@average_free_articles_published_weekly = average_free_articles_published_array_weekly.map { |day| day[1] }.inject{ |sum, el| sum + el }.to_f / average_free_articles_published_array_weekly.size		
		
		@average_premium_articles_published_weekly = average_premium_articles_published_array_weekly.map { |day| day[1] }.inject{ |sum, el| sum + el }.to_f / average_premium_articles_published_array_weekly.size

  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1/edit
  def edit
  end

  # POST /publications or /publications.json
  def create
    @publication = Publication.new(publication_params)

    respond_to do |format|
      if @publication.save
        format.html { redirect_to @publication, notice: "Publication was successfully created." }
        format.json { render :show, status: :created, location: @publication }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publications/1 or /publications/1.json
  def update
    respond_to do |format|
      if @publication.update(publication_params)
        format.html { redirect_to @publication, notice: "Publication was successfully updated." }
        format.json { render :show, status: :ok, location: @publication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publications/1 or /publications/1.json
  def destroy
    @publication.destroy
    respond_to do |format|
      format.html { redirect_to publications_url, notice: "Publication was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publication
      @publication = Publication.includes(:articles).find_by_slug(params[:slug])
    end

    # Only allow a list of trusted parameters through.
    def publication_params
      params.fetch(:publication, {})
    end
end
