class Comment < ActiveRecord::Base
  include Flaggable

  acts_as_paranoid column: :hidden_at
  include ActsAsParanoidAliases
  acts_as_votable
  has_ancestry touch: true

  attr_accessor :as_moderator, :as_administrator

  validates :body, presence: true
  validates :user, presence: true
  validates_inclusion_of :commentable_type, in: ["Debate", "Proposal"]

  validate :validate_body_length

  belongs_to :commentable, -> { with_hidden }, polymorphic: true, counter_cache: true
  belongs_to :user, -> { with_hidden }

  scope :recent, -> { order(id: :desc) }

  scope :sort_for_moderation, -> { order(flags_count: :desc, updated_at: :desc) }

  scope :for_render, -> { with_hidden.includes(user: :organization) }

  after_create :call_after_commented

  def self.build(commentable, user, body, p_id=nil)
    new commentable: commentable,
        user_id:     user.id,
        body:        body,
        parent_id:   p_id
  end

  def self.find_commentable(c_type, c_id)
    c_type.constantize.find(c_id)
  end

  def debate
    commentable if commentable.class == Debate
  end

  def author_id
    user_id
  end

  def author
    user
  end

  def author=(author)
    self.user= author
  end

  def total_votes
    cached_votes_total
  end

  def total_likes
    cached_votes_up
  end

  def total_dislikes
    cached_votes_down
  end

  def as_administrator?
    administrator_id.present?
  end

  def as_moderator?
    moderator_id.present?
  end

  def after_hide
    commentable_type.constantize.reset_counters(commentable_id, :comments)
  end

  def reply?
    !root?
  end

  def call_after_commented
    self.commentable.try(:after_commented)
  end

  def self.body_max_length
    1000
  end

  private

    def validate_body_length
      validator = ActiveModel::Validations::LengthValidator.new(
        attributes: :body,
        maximum: Comment.body_max_length)
      validator.validate(self)
    end

end
