class PageController < ApplicationController
  before_action :authenticate_user
  def index
    @person = Person.new
    @persons = Person.where(user_id: @user_id)
  end

  def create
    @person = Person.new(person_params)
    @person.user_id = @user_id
    if @person.save
      redirect_to page_index_path, notice: "บันทึกข้อมูลสำเร็จแล้ว!"
    else
      @persons = Person.all
      render :index
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])

    if @person.update(person_params)
      redirect_to page_index_path, notice: "แก้ไขข้อมูลสำเร็จแล้ว!"
    else
      render :edit
    end
  end

  def destroy
    @person = Person.find(params[:id])
    if @person.destroy
      redirect_to page_index_path, notice: "ลบข้อมูลสำเร็จแล้ว!"
    else
      redirect_to page_index_path, alert: "ไม่สามารถลบข้อมูลได้"
    end
  end

  def authenticate_user
    if session[:user_id].present?
      @user_id = session[:user_id]
      puts @user_id
    else
      redirect_to controller: :login, action: :index
    end
  end

  private

  def person_params
    params.require(:person).permit(:nickname, :birthdate, :note)
  end
end
