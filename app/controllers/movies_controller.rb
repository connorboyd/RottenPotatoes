class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    if !params.has_key?(:order)   #If params specifies an order, store it in the session and use that
      params[:order] = session[:order]
    else                          #Otherwise, use the order stored in the session
      session[:order] = params[:order]
    end

    if !params.has_key?(:ratings) #If params specifies the rating filters, store it in the session and use it
      params[:ratings] = session[:ratings]
    else                          #Otherwise, use the filter stored in the session
      session[:ratings] = params[:ratings]
    end



    @all_ratings = Movie.ratings  #Ratings array from the model
    @order = params[:order]   #Sort order from params hash

    #If ratings are specified, save the list of rating from the params. Otherwise, all ratings
    @ratings = params[:ratings] ? params[:ratings].values : @all_ratings

    if Movie.column_names.include? @order
      #Get movies list from the model, ordering by @order, and filtering the ratings
      @movies = Movie.find(:all, :order => @order, :conditions => ['rating in (?)', @ratings])
    else
      #Do not sort. Get movies from model
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
