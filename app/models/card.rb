require 'super_memo'

class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :block

  before_validation :set_review_date, on: :create

  validate :texts_are_unique
  validates :user_id, presence: true
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }
  validates :block_id,
            presence: { message: 'Выберите колоду из выпадающего списка.' }
  validates :interval, :repeat, :efactor, :quality, :attempt, presence: true

  mount_uploader :image, CardImageUploader

  scope :in_random_order, -> { order('RANDOM()') }
  scope :pending, -> { where('review_date <= ?', Time.zone.now).in_random_order }
  scope :repeating, -> { where('quality < ?', 4).in_random_order }

  def check_translation(user_translation)
    distance = levenshtein_distance user_translation
    sm_hash = super_memo_hash distance

    state = distance <= 1
    if state
      sm_hash.merge!(review_date: next_review_date, attempt: 1)
    else
      sm_hash.merge!(attempt: [attempt + 1, 5].min)
    end
    update(sm_hash)

    { state: state, distance: distance }
  end

  def self.pending_cards_notification
    users = User.where.not(email: nil)
    users.each do |user|
      if user.cards.pending.any?
        CardsMailer.pending_cards_notification(user.email).deliver
      end
    end
  end

  protected

  def levenshtein_distance(user_translation)
    Levenshtein.distance(full_downcase(translated_text), full_downcase(user_translation))
  end

  def super_memo_hash(distance)
    SuperMemo.algorithm(interval, repeat, efactor, attempt, distance, 1)
  end

  def set_review_date
    self.review_date = Time.zone.now
  end

  def next_review_date
    Time.zone.now + interval.to_i.days
  end

  def texts_are_unique
    if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, 'Вводимые значения должны отличаться.')
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
