module SpreeEasyGiftCards
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_easy_gift_cards\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_easy_gift_cards\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_easy_gift_cards\n", :before => /\*\//, :verbose => true
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_easy_gift_cards\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_easy_gift_cards'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def copy_initializer
        copy_file "spree_easy_gift_cards.rb", "config/initializers/spree_easy_gift_cards.rb"
      end

      def generate_gift_card_product
        puts "Initial Gift Card Setup contains:"
        puts "+ Digital Shipment category and method"
        puts "+ Gift Card Product"
        puts "+ Gift Card Variants (10,20, 50,100,200)"
        run_generator = ['', 'y', 'Y'].include?(ask 'Would you like to install the initial Gift Card setup? [Y/n]')
        if run_generator
          generate 'spree_easy_gift_cards:gift_card_product'
        else
          puts 'Skipping generator spree_easy_gift_cards:gift_card_product, make sure you know what you\'re doing!'
        end
      end
    end
  end
end
