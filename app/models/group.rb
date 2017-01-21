class Group < ActiveRecord::Base
  acts_as_tenant(:domain)

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :scoped], :scope => :domain_id

  paginates_per 25

  has_many :access_controls, :as => :user, :dependent => :destroy
  has_and_belongs_to_many :users
  belongs_to :user
  attr_accessor :user_ids
  attr_accessible :name, :status, :user_ids

  validates :name, :presence => true
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  validates :status, :inclusion => { :in => %w[private public] }, :allow_blank => false

  scope :for_user, lambda { |user| where('status = "public" or (status = "private" and user_id = ?)', user.id) }

  before_save :convert_user_ids

  def prePopulate
    users.map do |u|
      {id: u.id, name: u.name}
    end.to_json
  end

  private

  def convert_user_ids
    self.users = User.where(id: user_ids.split(',').map(&:to_i))
    self.users_count = self.users.count
  end

end
