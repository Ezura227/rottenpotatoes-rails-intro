class MoviesController < ApplicationController
  
  @@sort_by = nil
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    sortSel = params[:sort_by]
    #@sort_by = params[:sort_by]
    if !(sortSel.nil?)
      if (sortSel != '')
        session[:sort] = sortSel
      end
    end
    @select = params[:ratings]
    if (@select.nil?)
      if (session[:ratingFilters].nil?)
        session[:ratingFilters] = @all_ratings
      end #if the ratingFilters are already there, then no need to update them
    else
      session[:ratingFilters] = @select.keys
    end
    #puts "Select: #{@select}"
    #puts "Keys: #{temp}"
    #@movies = Movie.with_ratings(temp)
    #======================================
    #Actually queries
    @movies = Movie.where(rating: session[:ratingFilters])
    @movies = @movies.order(session[:sort])
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

end
