require 'sqlite3'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
# https://tomafro.net/2010/01/tip-relative-paths-with-file-expand-path
ROOT_FOLDER = File.join(File.dirname(__FILE__), '../../db')

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.setup(db_file_name, sql_file_name)
    sql_file = File.join(ROOT_FOLDER, sql_file_name)
    db_file = File.join(ROOT_FOLDER, db_file_name)

    commands = [
      "cat '#{sql_file}' | sqlite3 '#{db_file}'"
    ]

    commands.unshift("rm '#{db_file}'") if File.exist?(db_file)

    commands.each { |command| `#{command}` }
    DBConnection.open(db_file)
  end

  def self.instance
    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
