class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :owned_tasks
  has_many :participations, class_name: 'Participant' #class_name define el nombre de la clase que asociada 
  has_many :tasks, through: :participations
end
