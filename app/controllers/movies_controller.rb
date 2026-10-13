class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
    def index
      @needredir = false
      @all_ratings = Movie.all_ratings
      if params[:sort_by].nil? and not session[:sort_by].nil? and params[:home].nil?
        @redir_sort = session[:sort_by]
        @need_redir = true
      else
        @redir_sort = params[:sort_by]
      end
      if params[:ratings].nil? and not session[:ratings].nil? and params[:home].nil?
        @redir_rating = session[:ratings]
        @need_redir = true
      else
        @redir_rating = params[:ratings]
      end
      if @need_redir
        redirect_to movies_path(sort_by: @redir_sort, ratings:@redir_rating)
        return
      end
      session[:sort_by]= params[:sort_by]
      session[:ratings] = params[:ratings]
      if params[:home].nil?
        redirect_to movies_path(sort_by: params[:sort_by], ratings: Movie.all_ratings, home: 1)
      end
      if params[:ratings]
        @ratings_to_show = params[:ratings].keys
      else
        @ratings_to_show = @all_ratings
      end
      @sort_by = params[:sort_by]
      @movies = Movie.with_ratings(@ratings_to_show).order(@sort_by)
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
