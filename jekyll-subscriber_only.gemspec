# Copyright (c) 2023 Vitor Manuel de Sousa Pereira
# SPDX-License-Identifier: MIT

# frozen_string_literal: true

require_relative "lib/jekyll/subscriber_only/version"

Gem::Specification.new do |spec|
  spec.name     = "jekyll-subscriber_only"
  spec.version  = Jekyll::SubscriberOnly::VERSION
  spec.author   = "Vitor Manuel de Sousa Pereira"
  spec.email    = "vmsousapereira@gmail.com"
  spec.license  = "MIT"
  spec.homepage = "https://subscriber-only.com"

  spec.summary =
    "Monetize your Jekyll site with paid subscriber-only content."
  spec.description = <<-DESC
    Subscriber Only allows you to monetize your Jekyll site with paid
    subscriptions. Make selected content available only to paid subscribers by
    adding a single line to the post's front matter. Leave subscriptions,
    payment processing and access control to us and focus solely on making great
    content. Go to #{spec.homepage} for more details.
  DESC

  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]

  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" =>
      "https://github.com/subscriber-only/jekyll-subscriber_only",
  }

  spec.add_dependency "jekyll", ">= 3.7"
end
