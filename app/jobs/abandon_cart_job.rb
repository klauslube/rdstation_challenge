class AbandonCartJob < ApplicationJob
  queue_as :default

  def perform
    Cart.active.find_each(&:mark_as_abandoned!)
    Cart.abandoned.find_each(&:remove_if_abandoned!)
  end
end
