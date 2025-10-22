class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy
       
  has_many :cart_items, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def admin?
    role == 1 
  end

  def user?
    role == 0
  end

end
