class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    Boat.limit(5).to_a
  end

  def self.dinghy
    Boat.where("length < '20'").to_a
  end

  def self.ship
    Boat.where("length >= '20'").to_a
  end

  def self.last_three_alphabetically
    Boat.order(name: :desc).limit(3).to_a
  end

  def self.without_a_captain
    Boat.where(captain_id: nil)
  end

  def self.sailboats
    Boat.includes(:classifications).where(classifications: { name: 'Sailboat' })
  end

  def self.with_three_classifications
    # This is really complex! It's not common to write code like this
    # regularly. Just know that we can get this out of the database in
    # milliseconds whereas it would take whole seconds for Ruby to do the same.
    #
    Boat.joins(:classifications).group("boats.id").having("COUNT(*) = 3").select("boats.*")
  end

  def self.non_sailboats
    Boat.where("id NOT IN (?)", self.sailboats.pluck(:id))
  end

  def self.longest
    Boat.order('length DESC').first
  end
end
