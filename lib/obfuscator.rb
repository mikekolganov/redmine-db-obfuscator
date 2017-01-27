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
        attachments
        auth_sources
        boards
        changesets
        comments
        customers
        documents
        journal_details
        journals
        messages
        news
        queries
        repositories
        time_entries
        versions
        wiki_content_versions
        wiki_contents
        wiki_pages
        wiki_redirects
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
        db[:issues].select(:id).each do |issue|
          db[:issues].where(id: issue[:id]).update(
          subject: Faker::Lorem.sentence(4)[0, 255],
          description: Faker::Lorem.sentences(10).join(' ')
          )
        end
       end

      def obfuscate_projects
        puts 'Obfuscating projects.'
        db[:projects].select(:id).each do |project|
          db[:projects].where(id: project[:id]).update(
          name: Faker::Lorem.sentence(2)[0, 255],
          description: Faker::Lorem.sentences(10).join(' '),
          homepage: Faker::Internet.url,
          identifier: Faker::Lorem.word
          )
        end
      end

      def obfuscate_attachments
        puts 'Obfuscationg attachments'
        db[:attachments].select(:id).each do |attachment|
          db[:attachments].where(id: attachment[:id]).update(
          filename: Faker::Lorem.word,
          disk_filename: Faker::Lorem.word,
          description: Faker::Lorem.sentence
          )
        end
      end


        def obfuscate_auth_sources
          puts 'Obfuscationf Auth Sources'
          db[:auth_sources].select(:id).each do |auth_source|
            db[:auth_sources].where(id: auth_source[:id]).update(
                account: Faker::Internet.user_name,
                account_password: Faker::Internet.password
            )
          end
        end

        def obfuscate_boards
          puts 'Obfuscationg boards'
          db[:boards].select(:id).each do |board|
            db[:boards].where(id: board[:id]).update(
            name: Faker::Lorem.word,
            description: Faker::Lorem.sentence
            )
          end
        end

        def obfuscate_changesets
          puts 'Obfuscating changesets'
          db[:changesets].select(:id).each do |changeset|
            db[:changesets].where(id: changeset[:id]).update(
            committer: Faker::Internet.user_name,
            comments: Faker::Lorem.paragraph
            )
          end
        end

        def obfuscate_comments
          puts 'Obfuscating comments'
          db[:comments].select(:id).each do |comment|
            db[:comments].where(id: comment[:id]).update(
            comments: Faker::Lorem.paragraph
            )
          end
        end


    def obfuscate_customers
      puts 'Obfuscating customers'
      db[:customers].select(:id).each do |customer|
            db[:customers].where(id: customer[:id]).update(
            name: Faker::Name.name,
            company: Faker::Company.name,
            address: "#{Faker::Address.country},#{Faker::Address.city},#{Faker::Address.street_address}",
            phone: Faker::PhoneNumber.phone_number,
            website: Faker::Internet.url,
            skype_name: Faker::Internet.user_name
            )
          end
       end

    def obfuscate_documents
      puts 'Obfuscating documents'
      db[:documents].select(:id).each do |document|
        db[:documents].where(id: document[:id]).update(
        title: Faker::Lorem.word,
        description: Faker::Lorem.paragraph
        )
      end
    end

    def obfuscate_journal_details
      puts 'Obfuscating journal details'
      db[:journal_details].select(:id).each do |journal_detail|
        db[:journal_details].where(id: journal_detail[:id]).update(
        old_value: Faker::Lorem.paragraph,
        value: Faker::Lorem.paragraph
        )
      end
    end

    def obfuscate_journals
      puts 'Obfuscating journals'
      db[:journals].select(:id).each do |journal|
        db[:journals].where(id: journal[:id]).update(
        notes: Faker::Lorem.paragraph
        )
      end
    end

    def obfuscate_messages
      puts 'Obfuscating messages'
      db[:messages].select(:id).each do |message|
        db[:messages].where(id: message[:id]).update(
        content: Faker::Lorem.paragraph,
        subject: Faker::Lorem.sentence
        )
      end
    end

    def obfuscate_news
      puts 'Obfuscating news'
      db[:news].select(:id).each do |news|
        db[:news].where(id: news[:id]).update(
        summary: Faker::Lorem.sentence,
        title: Faker::Lorem.sentence[0, 60],
        description: Faker::Lorem.sentence
        )
      end
    end


    def obfuscate_queries
      puts 'Obfuscating queries'
      db[:queries].select(:id).each do |query|
        db[:queries].where(id: query[:id]).update(
        name: Faker::Lorem.word
        )
      end
    end

 def obfuscate_repositories
      puts 'Obfuscating repositories'
      db[:repositories].select(:id).each do |repository|
        db[:repositories].where(id: repository[:id]).update(
        url: Faker::Internet.url,
        login: Faker::Internet.user_name,
        password: Faker::Internet.password,
        root_url: Faker::Internet.url,
        extra_info: Faker::Lorem.sentence
        )
      end
    end


    def obfuscate_time_entries
      puts 'Obfuscating time entries'
      db[:time_entries].select(:id).each do |time_entry|
        db[:time_entries].where(id: time_entry[:id]).update(
        comments: Faker::Lorem.sentence(6)
        )
      end
    end

    def obfuscate_versions
      puts 'Obfuscating versions'
      db[:versions].select(:id).each do |version|
        db[:versions].where(id: version[:id]).update(
        name: Faker::Lorem.word,
        description: Faker::Lorem.sentence,
        wiki_page_title: Faker::Lorem.sentence(5)
        )
      end
    end

    def obfuscate_wiki_content_versions
      puts 'Obfuscating content versions'
      db[:wiki_content_versions].select(:id).each do |content_version|
        db[:wiki_content_versions].where(id: content_version[:id]).update(
        comments: Faker::Lorem.sentence,
        data: Faker::Lorem.sentence
        )
      end
    end

    def obfuscate_wiki_contents
      puts 'Obfuscating wiki contents'
      db[:wiki_contents].select(:id).each do |wiki_content|
        db[:wiki_contents].where(id: wiki_content[:id]).update(
        comments: Faker::Lorem.sentence
        )
      end
    end

    def obfuscate_wiki_pages
      puts 'Obfuscating wiki pages'
      db[:wiki_pages].select(:id).each do |wiki_page|
        db[:wiki_pages].where(id: wiki_page[:id]).update(
        title: Faker::Lorem.sentence
        )
      end
    end

    def obfuscate_wiki_redirects
      puts 'Obfuscating wiki redirects'
      db[:wiki_redirects].select(:id).each do |wiki_redirect|
        db[:wiki_redirects].where(id: wiki_redirect[:id]).update(
        title: Faker::Lorem.sentence,
        redirects_to: Faker::Internet.url
        )
      end
    end

 end
end
