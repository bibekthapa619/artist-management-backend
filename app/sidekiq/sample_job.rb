module SampleJob
  class CriticalJob
    include Sidekiq::Job
    sidekiq_options queue: 'critical'

    def perform(*args)
      puts "Critical job started"
      args.each do |arg|
        puts arg
      end
      puts "Critical job ended"
    end
  end

  class DefaultJob
    include Sidekiq::Job
    sidekiq_options queue: 'default'

    def perform(*args)
      puts "Default job started"
      args.each do |arg|
        puts arg
      end
      puts "Default job ended"
    end
  end

  class LowJob
    include Sidekiq::Job
    sidekiq_options queue: 'low'

    def perform(*args)
      puts "Low job started"
      args.each do |arg|
        puts arg
      end
      puts "Low job ended"
    end
  end
end
