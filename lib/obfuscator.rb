require 'rubygems'
require 'yaml'
require 'mysql2'
require 'sequel'
require 'faker'

I18n.enforce_available_locales = false

class Obfuscator
  class << self
    def db
      return @db if @db
      config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/database.yml'
      @db = Sequel.connect(YAML.load_file(config_file))
    end

    def obfuscate!
      puts 'Obfuscation started.'
      %w(
        users
        projects
        issues
      ).each { |m| send("obfuscate_#{m}".to_sym) }
      puts 'Obfuscation completed.'
    end

    private

      def obfuscate_users
        puts 'Obfuscating users.'
        db[:users].select(:id).each do |user|
          db[:users].where(id: user[:id]).update(
            login: Faker::Internet.user_name,
            hashed_password: '1b130fa7d1e947c9c330917cbf1a4b685555756f',
            salt: '0aacb7dd8deed04f67970531c86d13b0',
            firstname: Faker::Name.first_name,
            lastname: Faker::Name.last_name,
            mail: Faker::Internet.email,
            auth_source_id: nil
          )
        end
      end

      def obfuscate_issues
        puts 'Obfuscating issues.'
      end

      def obfuscate_projects
        puts 'Obfuscating projects.'
      end
  end
end
