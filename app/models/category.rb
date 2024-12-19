class Category < ApplicationRecord
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :status, presence: true, inclusion: { in: [ "Active", "Inactive" ] }

    has_many :products, dependent: :destroy

    after_initialize :set_default_status, if: :new_record?

    # scope :active, -> { where(status: 'Active') }
    # scope :inactive, -> { where(status: 'Inactive') }

    private

    def set_default_status
        self.status ||= "Inactive"
    end
end
