class User < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  belongs_to :current_block, class_name: 'Block'
  before_create :set_default_locale
  before_validation :set_default_locale, on: :create

  accepts_nested_attributes_for :authentications

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  FIELD_FORMAT = {
    email: /\A[^@]+@[^@]+\Z/
  }.freeze

  validates :password, confirmation: true, presence: true, length: { minimum: 3 }
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true, presence: true, format: { with: FIELD_FORMAT[:email] }
  validates :locale, presence: true,
                     inclusion: {
                       in: I18n.available_locales.map(&:to_s),
                       message: 'Выберите локаль из выпадающего списка.'
                     }

  def linked_github?
    authentications.where(provider: 'github').present?
  end

  def reset_current_block
    self.current_block_id = nil
  end

  def current_cards
    @current_cards ||= current_block ? current_block.cards : cards
  end

  def first_pending_or_repeating_card
    current_cards.pending.first || current_cards.repeating.first
  end

  private

  def set_default_locale
    self.locale = I18n.locale.to_s
  end
end
