require_relative 'db_connection'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    foreign_key = options[:foreign_key]
    primary_key = options[:primary_key]
    class_name = options[:class_name]

    @foreign_key = foreign_key.nil? ? "#{name}_id".to_sym : foreign_key
    @primary_key = primary_key.nil? ? :id : primary_key
    @class_name = class_name.nil? ? name.to_s.camelcase : class_name
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    foreign_key = options[:foreign_key]
    primary_key = options[:primary_key]
    class_name = options[:class_name]

    foreign_key_sym = "#{self_class_name.underscore}_id".to_sym
    class_name_default = name.to_s.singularize.camelcase

    @foreign_key = foreign_key.nil? ? foreign_key_sym : foreign_key
    @primary_key = primary_key.nil? ? :id : primary_key
    @class_name = class_name.nil? ? class_name_default : class_name
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name) do
      foreign_key = send(options.foreign_key)
      target_class = options.model_class
      target_class.where(options.primary_key => foreign_key).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    assoc_options[name] = options

    define_method(name) do
      primary_key = send(options.primary_key)
      target_class = options.model_class
      target_class.where(options.foreign_key => primary_key)
    end
  end

  def has_one_through(name, through_name, src_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      src_options = through_options.model_class.assoc_options[src_name]

      through_table = through_options.table_name
      src_table = src_options.table_name

      through_fkey = through_options.foreign_key
      through_pkey = through_options.primary_key

      src_fkey = src_options.foreign_key
      src_pkey = src_options.primary_key

      results = DBConnection.execute(<<-SQL, send(through_fkey))
        SELECT
          #{src_table}.*
        FROM
          #{through_table}
        JOIN
          #{src_table} ON #{through_table}.#{src_fkey} = #{src_table}.#{src_pkey}
        WHERE
          #{through_table}.#{through_pkey} = ?
      SQL

      src_options.model_class.parse_all(results).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end
