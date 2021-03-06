class WantsController < ApplicationController
  before_action :set_want, only: [:show, :edit, :update, :destroy]

  # GET /wants
  # GET /wants.json
  def index
    if session[:last]
      @last = session[:last]
    end
    @wants = Wants.all
    @hash = Gmaps4rails.build_markers(@wants) do |want, marker|
      if user_signed_in?
        if current_user.id == want.USER_ID
          info = "<div class=\"infowindow\"><h2>" + want.TITLE + " が欲しい！</h2><h3>user id: " + want.USER_ID.to_s + "</h3><p>" + want.COMMENT + "</p><p class=\"button-delete\"><a data-confirm=\"本当に削除しますか？?\" rel=\"nofollow\" data-method=\"delete\" href=\"/wants/" + want.id.to_s + "\">Destroy</a></p></div>";
        else 
          info = "<div class=\"infowindow\"><h2>" + want.TITLE + " が欲しい！</h2><h3>user id: " + want.USER_ID.to_s + "</h3><p>" + want.COMMENT + "</p></div>";
        end
      end
      marker.lat want.LATITUDE
      marker.lng want.LONGITUDE
      marker.infowindow info
    end
  end

  # GET /wants/1
  # GET /wants/1.json
  def show
  end

  # GET /wants/new
  def new
    @want = Wants.new
  end

  # GET /wants/1/edit
  def edit
  end

  # POST /wants
  # POST /wants.json
  def create
    @want = Wants.new(want_params)
    last = {:LATITUDE => @want.LATITUDE, :LONGITUDE => @want.LONGITUDE}
    respond_to do |format|
      if @want.save
        session[:last] = last
        format.html { redirect_to wants_path, notice: 'Wants was successfully created.' }
        format.json { render :show, status: :created, location: @want }
      else
        format.html { render :new }
        format.json { render json: @want.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wants/1
  # PATCH/PUT /wants/1.json
  def update
    respond_to do |format|
      if @want.update(want_params)
        format.html { redirect_to @want, notice: 'Wants was successfully updated.' }
        format.json { render :show, status: :ok, location: @want }
      else
        format.html { render :edit }
        format.json { render json: @want.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wants/1
  # DELETE /wants/1.json
  def destroy
    @want.destroy
    respond_to do |format|
      format.html { redirect_to wants_url, notice: 'Wants was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_want
      @want = Wants.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def want_params
      #params.require(:want).permit(:USER_ID, :TITLE, :CATEGORY_ID, :COMMENT, :LATITUDE, :LONGITUDE)
      params.require('wants').permit(:USER_ID, :TITLE, :CATEGORY_ID, :COMMENT, :LATITUDE, :LONGITUDE)
    end
end
