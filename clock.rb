require 'clockwork'
include Clockwork

every(10.seconds, 'frequent.job') {
  puts "job is running"
}
