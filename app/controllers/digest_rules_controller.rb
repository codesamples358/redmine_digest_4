class DigestRulesController < ApplicationController

  PREVIEW_ISSUE_LIMIT = 20

  before_action :set_user

  def new
    @digest_rule = @user.digest_rules.build
  end

  def create
    @digest_rule = @user.digest_rules.build(digest_params)
    if @digest_rule.save
      redirect_to controller: 'my', action: 'account'
    else
      render action: 'new'
    end
  end

  def edit
    @digest_rule = @user.digest_rules.find(params[:id])
  end

  def update
    @digest_rule = @user.digest_rules.find(params[:id])
    if @digest_rule.update_attributes(digest_params)
      redirect_to controller: 'my', action: 'account'
    else
      render action: 'edit'
    end
  end

  def destroy
    digest_rule = @user.digest_rules.find(params[:id])
    digest_rule.destroy
    redirect_to controller: 'my', action: 'account'
  end

  def show
    digest_rule = @user.digest_rules.find(params[:id])
    @digest     = RedmineDigest::Digest.new(digest_rule, Time.now, PREVIEW_ISSUE_LIMIT)
    render layout: 'digest'
  end

  private

  def set_user
    @user = User.current
  end

  def digest_params
    params.require(:digest_rule).permit(:active, :name, :raw_project_ids, :project_selector, :notify, :recurrent, :event_ids, :move_to, :template)
  end
end
