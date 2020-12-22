class Captain < ActiveRecord::Base
  has_many :boats

  def self.catamaran_operators
    includes(boats: :classifications).where(classifications: {name: "Catamaran"})
    # https://api.rubyonrails.org/v6.1.0/classes/ActiveRecord/QueryMethods.html#method-i-includes
  end

  def self.sailors
    includes(boats: :classifications).where(classifications: {name: "Sailboat"}).distinct
    # https://api.rubyonrails.org/v6.1.0/classes/ActiveRecord/QueryMethods.html#method-i-distinct
  end

  def self.motorboat_operators
    includes(boats: :classifications).where(classifications: {name: "Motorboat"})
  end

  def self.talented_seafarers
    where("id IN (?)", self.sailors.pluck(:id) & self.motorboat_operators.pluck(:id))
    # this uses two class methods defined earlier within this class
    # checks for items where both are true (???)
    # https://www.w3schools.com/sql/sql_and_or.asp#:~:text=SQL%20AND%2C%20OR%20and%20NOT%20Operators&text=The%20AND%20and%20OR%20operators,separated%20by%20OR%20is%20TRUE.
  end

  def self.non_sailors
    where.not("id IN (?)", self.sailors.pluck(:id))
    # https://api.rubyonrails.org/v6.1.0/classes/ActiveRecord/QueryMethods/WhereChain.html#method-i-not
  end

end
