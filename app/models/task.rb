class Task < ApplicationRecord
  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participanting_users, class_name: 'Participant', dependent: :destroy # como participanting_user no existe se asocia al model Participant
  has_many :participants, through: :participanting_users, source: :user # nombre de la fuente que hara uso la relacion (User)

  has_many :notes

  validates :participanting_users, presence: true  #valida la relacion
  validates_presence_of :name, :description
  validates :name, uniqueness: {case_sensitive: false} 
  validate :error_date

    before_create :create_code #Callback 
    after_create :send_email

  accepts_nested_attributes_for :participanting_users, allow_destroy: true

    def error_date
        if due_date < Date.today
            errors.add(:due_date, "no se puede crear en pasado")
        end
    end

    def create_code
        self.code = "#{owner_id}#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}"
        # Code = id del owner + prefijo de estampa de tiempo, en entero luego a un string en base 36 +
        # SecureRandom = metodo de rails para una condicion de unicidad y se cumpla 
        # hex(8) = cantidad de bytes utilizados para el codigo 
    end
    
    def send_email
        (participants + [owner]).each do |user|
            ParticipantMailer.with(user: user, task: self).new_task_email.deliver!
        end
    end
end
