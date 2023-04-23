# Jekyll Subscriber Only

Monetize your Jekyll site with paid subscriber-only content.

Subscriber Only allows you to monetize your Jekyll site with paid subscriptions. Make selected content available only to paid subscribers by adding a single line to the post's front matter. Leave subscriptions, payment processing and access control to us and focus solely on making great content. Go to https://subscriber-only.com for more details.

## Installation

First, you need to [sign up on Subscriber Only](https://app.subscriber-only.com/site/new) -- it's easy, it takes 10 minutes!

Then, add the `jekyll-subscriber_only` gem to your application's Gemfile, in the `jekyll_plugins` group. Make sure it comes after `jekyll-feed`, if you're using it:

```ruby
group :jekyll_plugins do
  # gem "jekyll-feed", "~> 0.12"
  gem "jekyll-subscriber_only"
end
```

And then execute:

    $ bundle install

Finally, copy your tokens to your site's `_config.yml`:

```yaml
subscriber_only:
  public_token: MY_PUBLIC_TOKEN
  secret_token: MY_SECRET_TOKEN
```

## Usage

If you want to make a particular post subscriber-only, add `subscriber_only: true` to the post's front matter:

```yml
layout: post
title: My premium post
subscriber_only: true
```

**That's it!**

Note that your posts will only be paywalled when building with `JEKYLL_ENV=production`. I.e.

    $ JEKYLL_ENV=production bundle exec jekyll build

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/subscriber-only/jekyll-subscriber_only.

