namespace :scheduler do
  desc "Take for send message schuled every time to replace for sidekiq worker because worker dyno off if no traffic to web dyno"
  task :send_message, [:cron_period] => [:environment] do |task, args|
    args[:cron_period].to_i.times do |i|
      start_time = Time.now
      puts "Task running at #{start_time.to_s}"
      puts args

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

      remainning = Time.now.end_of_minute - start_time if Time.now.strftime("%M") == start_time.strftime("%M")
      puts "Waiting for new in task #{remainning} seconds"
      puts "End task at #{Time.now.to_s}"
      sleep(remainning) if remainning && remainning > 0 && (i != args[:cron_period].to_i - 1)
    end
  end
end
