namespace :cart do
  desc 'Process abandoned carts - marks inactive carts as abandoned and removes old ones'
  task abandon: :environment do
    puts "[#{Time.current}] Starting cart abandonment process..."
    
    AbandonCartJob.perform_later
    
    puts "[#{Time.current}] AbandonCartJob enqueued successfully!"
  end
end