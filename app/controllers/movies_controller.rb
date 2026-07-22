class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    # Load Session
    if params[:sort_by] == nil and params[:ratings] == nil
      sort_by = session[:sort_by]
      ratings = session[:ratings]
    else
      sort_by = params[:sort_by]
      ratings = params[:ratings]
    end
    # Sorting Decider
    if sort_by == 'release_date'
      @options_for_select = [["Release date", "release_date"], ["Title", "title"]]
    else 
      @options_for_select = [["Title", "title"], ["Release date", "release_date"]]
    end
    # Setup Checkboxes
    @all_ratings = Movie.all_ratings
    if ratings == nil or ratings.empty?
      @ratings_to_show = @all_ratings
    else 
      @ratings_to_show = ratings.keys
    end
    # Select Movies
    if ratings == nil
      @movies = Movie.all.order(sort_by)
    else
      @movies = Movie.with_ratings(ratings.keys).order(sort_by)
    end
    # Save Session
    session[:sort_by] = sort_by
    session[:ratings] = ratings
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
