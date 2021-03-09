class Task < ApplicationRecord
  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participanting_users, class_name: 'Participant', dependent: :destroy # como participanting_user no existe se asocia al model Participant
  has_many :participants, through: :participanting_users, source: :user # nombre de la fuente que hara uso la relacion (User)

  validates :participanting_users, presence: true  #valida la relacion
  validates_presence_of :name, :description
  validates :name, uniqueness: {case_sensitive: false} 
  validate :error_date

  accepts_nested_attributes_for :participanting_users, allow_destroy: true

    def error_date
        if due_date < Date.today
            errors.add(:due_date, "no se puede crear en pasado")
        end
    end

end
