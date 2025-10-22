# app/policies/item_policy.rb
class ItemPolicy < ApplicationPolicy
  def index?
    true  # Everyone can view items
  end

  def show?
    true
  end

  def create?
    user.admin?
  end

  def new?
   user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
