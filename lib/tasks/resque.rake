namespace :resque do
  desc "Retries failed jobs and clears the failed jobs queue"
  task :retry_killed => :environment do
    (Resque::Failure.count-1).downto(0).each do |i|
      job = Resque::Failure.all(i)
      ex = job['exception'] || ''
      if ex.include?('Resque::TermException') || ex.include?('Resque::DirtyExit')
        Resque::Failure.requeue(i)
        Resque::Failure.remove(i)
      end
    end
  end
end
