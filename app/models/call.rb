class Call < ApplicationRecord
  belongs_to :shift
  belongs_to :vehicle
  
  before_save :update_timestamps

  after_create_commit :broadcast_create
  after_update_commit :broadcast_update

  validates :fare, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :distance, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :duration, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validates :status, presence: true, inclusion: { in: %w[waiting in_progress completed canceled] }
  validates :pickup_address, presence: true
  validates :passenger_count, numericality: { greater_than_or_equal_to: 1 }, allow_nil: false
  
  # Additional validations and methods can be added here as needed


  def pickup
    self.status = 'in_progress'
    self.picked_up_at_time = Time.current

    self.save
    ActionCable.server.broadcast('calls_channel', {action: 'pickup_call', call: self.as_json})
  end

  def dropoff
    self.status = 'completed'
    self.dropped_off_at_time = Time.current
    self.save
    ActionCable.server.broadcast('calls_channel', {action: 'dropoff_call', call: self.as_json})
  end

  def cancel
    self.status = 'canceled'
    self.canceled_at_time = Time.current
    self.picked_up_at_time = nil
    self.dropped_off_at_time = nil
    self.scheduled_pickup_time = nil
    self.save
    ActionCable.server.broadcast('calls_channel', {action: 'cancel_call', call: self.as_json})
  end

  def uncancel
    self.status = "waiting"
    self.save
  end

  def changeShift(new_shift)
    if new_shift.is_a?(Shift)
      self.shift_id = new_shift.id
      self.vehicle_id = new_shift.vehicle_id if new_shift.vehicle_id.present?
      self.status = 'waiting' # Reset status to waiting when changing shift
      self.picked_up_at_time = nil
      self.dropped_off_at_time = nil
      self.canceled_at_time = nil
      self.save
    end
  end

  private

  def broadcast_create
    ActionCable.server.broadcast('calls_channel', {action: 'new_call', call: self.as_json})
  end

  def broadcast_update
    ActionCable.server.broadcast('calls_channel', {action: 'update_call', call: self.as_json})
  end

  def update_timestamps

    if shift_id_changed? && status == 'waiting'
      self.picked_up_at_time = nil
      self.dropped_off_at_time = nil
      self.canceled_at_time = nil
    elsif shift_id_changed? && status == 'in_progress'
      self.picked_up_at_time = Time.current
      self.dropped_off_at_time = nil
      self.canceled_at_time = nil
    elsif shift_id_changed? && status == 'completed'
      self.picked_up_at_time = nil
      self.dropped_off_at_time = Time.current
      self.canceled_at_time = nil
    end

    if status_changed? && status == 'in_progress'
      self.picked_up_at_time = Time.current
      self.dropped_off_at_time = nil
      self.canceled_at_time = nil
    elsif status_changed? && status == 'completed'
      self.dropped_off_at_time = Time.current
      self.canceled_at_time = nil
    elsif status_changed? && status == 'canceled'
      self.picked_up_at_time = nil
      self.dropped_off_at_time = nil
      self.scheduled_pickup_time = nil
      self.canceled_at_time = Time.current
    elsif status_changed? && status == 'waiting'
      self.dropped_off_at_time = nil
      self.picked_up_at_time = nil
      self.canceled_at_time = nil
    end
  end

end