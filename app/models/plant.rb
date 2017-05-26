class Plant < Organism
  has_many :tasks, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  accepts_nested_attributes_for :tasks, allow_destroy: true
end
