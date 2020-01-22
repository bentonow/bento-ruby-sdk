require "time"

require "bento/sdk/defaults"
require "bento/sdk/logging"
require "bento/sdk/utils"
require "bento/sdk/worker"

module Bento
  class Analytics
    class Client
      include Bento::Analytics::Utils
      include Bento::Analytics::Logging

      # @param [Hash] opts
      # @option opts [String] :write_key Your project's write_key
      # @option opts [FixNum] :max_queue_size Maximum number of calls to be
      #   remain queued.
      # @option opts [Proc] :on_error Handles error calls from the API.

      def initialize(opts = {})
        symbolize_keys!(opts)

        @queue = Queue.new
        @write_key = opts[:write_key]

        logger.debug("🍱Tracked events will be sent to: #{@write_key}")

        @max_queue_size = opts[:max_queue_size] || Defaults::Queue::MAX_SIZE
        @worker_mutex = Mutex.new
        @worker = Bento::Analytics::Worker.new(@queue, @write_key, opts)
        @worker_thread = nil

        check_write_key!

        at_exit { @worker_thread && @worker_thread[:should_exit] = true }
      end

      # Synchronously waits until the worker has flushed the queue.
      #
      # Use only for scripts which are not long-running, and will specifically
      # exit
      def flush
        while !@queue.empty? || @worker.is_requesting?
          ensure_worker_running
          sleep(0.1)
        end
      end

      # @!macro common_attrs
      #   @option attrs [String] :anonymous_id ID for a user when you don't know
      #     who they are yet. (optional but you must provide either an
      #     `anonymous_id` or `user_id`)
      #   @option attrs [Hash] :context ({})
      #   @option attrs [Hash] :integrations What integrations this event
      #     goes to (optional)
      #   @option attrs [String] :message_id ID that uniquely
      #     identifies a message across the API. (optional)
      #   @option attrs [Time] :timestamp When the event occurred (optional)
      #   @option attrs [String] :user_id The ID for this user in your database
      #     (optional but you must provide either an `anonymous_id` or `user_id`)
      #   @option attrs [Hash] :options Options such as user traits (optional)

      # Tracks an event
      #
      # @param [Hash] attrs
      #
      # @option attrs [String] :event Event name
      # @option attrs [Hash] :properties Event properties (optional)
      # @macro common_attrs

      def track(attrs)
        symbolize_keys! attrs
        track_but_parsed = FieldParser.parse_for_track(attrs, @write_key)
        enqueue(track_but_parsed)
      end

      # @return [Fixnum] number of messages in the queue
      def queued_messages
        @queue.length
      end

      private

      # private: Enqueues the action.
      #
      # returns Boolean of whether the item was added to the queue.
      def enqueue(action)
        if @queue.length < @max_queue_size
          @queue << action
          ensure_worker_running

          true
        else
          logger.warn(
            "Queue is full, dropping events. The :max_queue_size " \
            "configuration parameter can be increased to prevent this from " \
            "happening."
          )
          false
        end
      end

      # private: Checks that the write_key is properly initialized
      def check_write_key!
        raise ArgumentError, "Write key must be initialized" if @write_key.nil?
      end

      def ensure_worker_running
        return if worker_running?
        @worker_mutex.synchronize do
          return if worker_running?
          @worker_thread = Thread.new {
            @worker.run
          }
        end
      end

      def worker_running?
        @worker_thread&.alive?
      end
    end
  end
end
