class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    all.limit(5) # `all` being called implicitly on `self`? in this case `self` = Boat class
  end

  def self.dinghy
    where("length < 20") # length is less than 20
  end

  def self.ship
    where("length >= 20") # length is greater than or equal to 20
  end

  def self.last_three_alphabetically
    all.order(name: :desc).limit(3) # reverse-alphabetically order every Boat row in the table, then retrieve only (the first) 3 of that list
  end

  def self.without_a_captain
    where(captain_id: nil) # find ships without an associated captain
  end

  def self.sailboats
    includes(:classifications).where(classifications: { name: 'Sailboat' }) # https://api.rubyonrails.org/v6.1.0/classes/ActiveRecord/QueryMethods.html#method-i-includes
    # "Specify relationships to be included in the result set." read link for more info on `includes` + `where` conditions chained onto them, along with `references`
    # this has something to do with the `boat_classifications` and `classifications` tables?
    # `SQL (2.1ms)  SELECT "boats"."id" AS t0_r0, "boats"."name" AS t0_r1, "boats"."length" AS t0_r2, "boats"."captain_id" AS t0_r3, "boats"."created_at" AS t0_r4, "boats"."updated_at" AS t0_r5, "classifications"."id" AS t1_r0, "classifications"."name" AS t1_r1, "classifications"."created_at" AS t1_r2, "classifications"."updated_at" AS t1_r3 FROM "boats" LEFT OUTER JOIN "boat_classifications" ON "boat_classifications"."boat_id" = "boats"."id" LEFT OUTER JOIN "classifications" ON "classifications"."id" = "boat_classifications"."classification_id" WHERE "classifications"."name" = ?  [["name", "Sailboat"]]``
  end

  def self.with_three_classifications
    # This is really complex! It's not common to write code like this
    # regularly. Just know that we can get this out of the database in
    # milliseconds whereas it would take whole seconds for Ruby to do the same.
    # https://api.rubyonrails.org/v6.1.0/classes/ActiveRecord/QueryMethods.html#method-i-joins
    joins(:classifications).group("boats.id").having("COUNT(*) = 3").select("boats.*")
  end

  def self.non_sailboats
    where("id NOT IN (?)", self.sailboats.pluck(:id))
    # pluck can be used to query single or multiple columns from the underlying table of a model. It accepts a list of column names as an argument and returns an array of values of the specified columns with the corresponding data type.
    # https://guides.rubyonrails.org/active_record_querying.html#pluck
  end

  def self.longest
    order('length DESC').first
    # https://guides.rubyonrails.org/active_record_querying.html#ordering
  end
end
