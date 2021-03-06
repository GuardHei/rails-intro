class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if not params.has_key?(:ratings) and not params.has_key?(:sorting)
      if session.has_key?(:rating) or session.has_key?(:sorting)
        @ratings = session[:ratings]
        @sorting = session[:sorting]
        redirect_to movies_path(:sorting => @sorting, :ratings => @ratings)
      end
    else
      @ratings = params[:ratings]
      @sorting = params[:sorting]
      session[:ratings] = @ratings
      session[:sorting] = @sorting
    end
    if not @ratings.nil?
      @ratings_to_show = @ratings.keys
      @movies = Movie.with_ratings(@ratings_to_show, @sorting)
    else
      @ratings_to_show = @all_ratings
      @movies = Movie.with_ratings(@ratings_to_show, @sorting)
    end
    @title_class = ""
    @release_date_class = ""
    if not @sorting.nil?
      if @sorting == "title"
        @title_class = "hilite bg-warning"
      elsif @sorting == "release_date"
        @release_date_class = "hilite bg-warning"
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
