class PageController < ApplicationController
  def index
    @person = Person.new
    @persons = Person.all
  end

  def create
    @person = Person.new(person_params)

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

  private

  def person_params
    params.require(:person).permit(:nickname, :birthdate, :note)
  end
end
