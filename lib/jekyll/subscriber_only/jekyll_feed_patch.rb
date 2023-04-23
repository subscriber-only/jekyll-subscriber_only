# Copyright (c) 2023 Vitor Manuel de Sousa Pereira
# SPDX-License-Identifier: MIT

# frozen_string_literal: true

module Jekyll
  module SubscriberOnly
    module JekyllFeedPatch
      private

      def feed_source_path
        @feed_source_path ||= File.expand_path("feed.xml", __dir__)
      end
    end
  end
end

if Object.const_defined?("JekyllFeed::Generator")
  JekyllFeed::Generator.prepend(Jekyll::SubscriberOnly::JekyllFeedPatch)
end
