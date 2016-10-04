module Resque
  module Failure

    # Logs failure messages.
    class Logger < Base
      def save
        Rails.logger.error detailed
      end

      def detailed
        <<-EOF
Resque worker #{worker} failed while processing #{queue}:
Payload:
#{payload.inspect.split("\n").map { |l| "  " + l }.join("\n")}
Exception:
  #{exception}
#{format_backtrace}
        EOF
      end

      def format_backtrace
        if exception.backtrace
          exception.backtrace.map { |l| "  " + l }.join("\n")
        end
      rescue
        nil
      end
    end

    # Emails failure messages.
    class Notifier < Logger
      class << self
        attr_accessor :configuration
      end

      def self.configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end

      def save
        text, subject = detailed, "[Resque Error] #{worker} #{exception.class.to_s}"

        ActionMailer::Base.mail(
          from: Notifier.configuration.from,
          to: Notifier.configuration.to,
          subject: subject,
          body: text
        ).deliver_now

      rescue
        Rails.logger.error $!
      end

      class Configuration
        attr_accessor :from, :to

        def initialize
          @from = 'donotreply@example.com'
          @to = 'test@example.com'
        end
      end
    end

  end
end
