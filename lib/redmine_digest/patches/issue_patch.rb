require_dependency 'issue'
require 'active_support/concern'

module RedmineDigest
  module Patches
    module IssuePatch
      extend ActiveSupport::Concern

      included do
        alias_method_chain :recipients, :digest_filter
        alias_method_chain :watcher_recipients, :digest_filter

        before_save :set_assigned_to_was
      end

      def recipients_with_digest_filter
        found_mails = recipients_without_digest_filter
        found_users = found_mails.map { |mail| User.find_by_mail(mail) }
        found_users.reject do |found_user|
          found_user.skip_issue_add_notify?(self)
        end.map(&:mail)
      end

      def watcher_recipients_with_digest_filter
        found_mails    = watcher_recipients_without_digest_filter
        found_watchers = found_mails.map { |mail| User.find_by_mail(mail) }
        found_watchers.reject do |found_watcher|
          found_watcher.skip_issue_add_notify?(self)
        end.map(&:mail)
      end

      # Returns the previous assignee (user or group) if changed
      def assigned_to_was
        # assigned_to_id_was is reset before after_save callbacks
        user_id = @previous_assigned_to_id || assigned_to_id_was
        if user_id && user_id != assigned_to_id
          @assigned_to_was ||= Principal.find_by_id(user_id)
        end
      end

      # Stores the previous assignee so we can still have access
      # to it during after_save callbacks (assigned_to_id_was is reset)
      def set_assigned_to_was
        @previous_assigned_to_id = assigned_to_id_was
      end

      # Clears the previous assignee at the end of after_save callbacks
      def clear_assigned_to_was
        @assigned_to_was = nil
        @previous_assigned_to_id = nil
      end
    end
  end
end
