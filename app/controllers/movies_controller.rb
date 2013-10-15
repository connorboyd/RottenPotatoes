class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    if !params.has_key?(:order)
      params[:order] = session[:order]
    else
      session[:order] = params[:order]
    end

    if !params.has_key?(:ratings)
      params[:ratings] = session[:ratings]
    else
      session[:ratings] = params[:ratings]
    end



    @all_ratings = Movie.ratings
    @order = params[:order]
    @ratings = params[:ratings] ? params[:ratings].values : @all_ratings
    if Movie.column_names.include? @order
      @movies = Movie.find(:all, :order => @order, :conditions => ['rating in (?)', @ratings])
    else
      @movies = Movie.find(:all, :conditions => ['rating in (?)', @ratings])
    end

    session = params
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
