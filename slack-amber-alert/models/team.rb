class Team
  field :notified_at, type: DateTime
  field :welcomed_at, type: DateTime
  field :api, type: Boolean, default: false

  scope :api, -> { where(api: true) }

  def notified!(ts)
    return if notified_at && notified_at > ts
    update_attributes!(notified_at: ts)
  end
end
