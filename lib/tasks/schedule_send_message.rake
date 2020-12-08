desc "Take for send message schuled every time to replace for sidekiq worker because worker dyno off if no traffic to web dyno"
task :send_message => :environment do
  time_range = [1.minutes.ago.beginning_of_minute, Time.now.beginning_of_minute]
  Sidekiq::ScheduledSet.new.each do |job|
    puts "Starting schuled message at #{Time.now.to_s}"

    begin
      message = Message.find_by(id: job.args[0])
      next unless message || message.status == Message.status.processing
      next unless time_range.any? { |time| time == job.at }
      message.update!(status: Message.status.processing)

      puts "Processing message #{message.id}"

      job.klass.constantize.new.perform(*job.args)
      job.delete
    rescue StandardError => e
      puts e.message
    end
  end
end
