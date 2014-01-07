class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!

  # GET /groups
  # GET /groups.json
  def index
    @groups = []
    for member in current_user.members
      @groups << member.group
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show

  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    redirect_to :action => :index and return unless is_owner?
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    member = Member.create
    @group.members << member
    current_user.members << member

    @group.owner = member

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    redirect_to :action => :index and return unless is_owner?
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    redirect_to :action => :index and return unless is_owner?
    for member in @group.members
      member.destroy
    end
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      if is_user_member_of_group? current_user, Group.find(params[:id])
        @group = Group.find(params[:id])
      else
        @group = Group.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name)
    end

    def is_owner?
      if @group.owner.user == current_user
        return true
      else
        flash[:alert] = 'Nur der Owner einer Gruppe kann das tun!'
        return false
      end
    end

    def is_user_member_of_group?(user, group)
      for member in user.members
        if member.group == group
          return true
        end
      end
      return false
    end
end
