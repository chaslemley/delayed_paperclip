require 'resque'
require 'resque-retry'

module DelayedPaperclip
  module Jobs
    class Resque
      @queue = :paperclip

      def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
        if instance_klass.to_s == "CustomerPhoto"
          ::Resque.enqueue_to("customer_photo", self, instance_klass, instance_id, attachment_name)
        else
          ::Resque.enqueue(self, instance_klass, instance_id, attachment_name)
        end
      end

      def self.perform(instance_klass, instance_id, attachment_name)
        DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name)
      end
    end
  end
end