class Note < ActiveRecord::Base
  validates :text, presence: true
  validates :creator_id, presence: true
  validates :recipient_id, presence: true

  def self.next(id)
    self.where("id > ?", id).first
  end

  def self.previous(id)
    self.where("id < ?", id).last
  end

  def self.random
    self.order(Arel.sql('RANDOM()')).first
  end
end
