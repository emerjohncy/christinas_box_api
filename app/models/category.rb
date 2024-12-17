class Category < ApplicationRecord
    validates :name, presence: true
    validates :status, presence: true, inclusion: { in: [ "Active", "Inactive" ] }

    after_initialize :set_default_status, if: :new_record?

    # scope :active, -> { where(status: 'Active') }
    # scope :inactive, -> { where(status: 'Inactive') }

    def deactivate
        update(status: "Inactive")
    end

    private

    def set_default_status
        self.status ||= "Inactive"
    end
end
