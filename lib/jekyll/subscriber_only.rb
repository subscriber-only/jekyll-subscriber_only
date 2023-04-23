# Copyright (c) 2023 Vitor Manuel de Sousa Pereira
# SPDX-License-Identifier: MIT

# frozen_string_literal: true

require "net/http"
require "uri"

require "jekyll"

require "jekyll/subscriber_only/jekyll_feed_patch"
require "jekyll/subscriber_only/version"

module Jekyll
  module SubscriberOnly
    extend self

    Conf = Struct.new(
      :env, :public_token, :secret_token, :base_url, :script_url, :upload_url,
      keyword_init: true
    )

    def configure(site)
      jekyll_conf = site.config["subscriber_only"]
      base_url = "https://app.subscriber-only.com"

      if jekyll_conf.nil?
        die("The site must be configured before you're able to make your " \
            "posts subscriber-only. Go to #{new_site_url} to configure the " \
            "site.")
      end

      env = jekyll_conf["env"]
      base_url = "http://localhost:3000" if env == "development"

      @conf = Conf.new(
        env: env,
        public_token: jekyll_conf["public_token"],
        secret_token: jekyll_conf["secret_token"],
        base_url: base_url,
        script_url: "#{base_url}/so.js",
        upload_url: URI("#{base_url}/api/v1/posts"),
      )

      return unless @conf.public_token.nil? || @conf.secret_token.nil?

      die("Public and secret tokens must be configured to enable subscriber-" \
          "only posts. Go to #{edit_site_url} to get the tokens.")
    end

    def paywall(doc)
      return unless subscriber_only?(doc)

      info("Paywalling post \"#{doc['title']}\"")
      upload_post(doc)
      replace_content(doc)
    end

    private

    def upload_post(doc)
      res = Net::HTTP.post(
        @conf.upload_url,
        { path: doc.url, title: doc["title"], content: doc.content }.to_json,
        {
          Authorization: "Bearer #{@conf.secret_token}",
          Accept: "application/json",
          "Content-Type": "application/json",
        },
      )

      handle_api_error(res)
    rescue Errno::ECONNREFUSED
      die("Failed to connect to #{@conf.base_url}. Please contact us if this " \
          "issue persists.")
    rescue JSON::ParserError
      File.write("parser_error.html", res.body) if @conf.env == "development"
      die("Failed to get a correct response.")
    end

    def handle_api_error(res)
      return if res.is_a?(Net::HTTPSuccess)

      error_details = JSON.parse(res.body)
      die("Failed to upload \"#{doc['title']}\".\n#{error_details['message']}")
    end

    def replace_content(doc)
      doc.output.sub!("</head>", "#{head_html}</head>")
      doc.output.sub!(doc.content, content_html)
    end

    def head_html
      "<script type=\"module\" src=\"#{@conf.script_url}\"></script>"
    end

    def content_html
      "<div data-subscriber-only data-public-token=\"#{@conf.public_token}\">" \
        "</div>"
    end

    def new_site_url
      "#{@conf.base_url}/site/edit"
    end

    def edit_site_url
      "#{@conf.base_url}/site/edit"
    end

    def subscriber_only?(doc)
      Jekyll.env == "production" &&
        !doc.draft? &&
        doc.published? &&
        doc.write? &&
        doc["subscriber_only"] == true
    end

    def info(message)
      Jekyll.logger.info("Subscriber-Only:", message)
    end

    def die(message)
      Jekyll.logger.error("Subscriber-Only:", message)
      # Jekyll's command handler catches all Exceptions so we must be more brusque
      # when aborting or the user will be drowning in stack traces.
      exit!
    end
  end
end

Jekyll::Hooks.register(:site, :after_init) do |site|
  Jekyll::SubscriberOnly.configure(site)
end

Jekyll::Hooks.register(:posts, :post_render) do |doc|
  Jekyll::SubscriberOnly.paywall(doc)
end
