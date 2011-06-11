##
# A MySQL connection:
# DataMapper.setup(:default, 'mysql://user:password@localhost/the_database_name')
#
# # A Postgres connection:
# DataMapper.setup(:default, 'postgres://user:password@localhost/the_database_name')
#
# # A Sqlite3 connection
# DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "development.db"))
#

DataMapper.logger = logger
DataMapper::Property::String.length(255)

case Padrino.env
  when :development
    # DataMapper.setup(:default, 'postgres://akshayd@localhost/mcdfinder_development')
    DataMapper.setup(:default, "mysql://root@localhost/mcdfinder_development")
    # DataMapper::Adapters::PostgresAdapter::SQL.module_eval do
    DataMapper::Adapters::MysqlAdapter::SQL.module_eval do
      def quote_name(name)
        if name.include? '('
          name
        else
          "`#{name[0, self.class::IDENTIFIER_MAX_LENGTH].gsub('`.`', '.')}`"
        end
      end
    end
  # when :production  then DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://my.db')
  when :production
    # DataMapper.setup(:default, 'postgres://akshayd@localhost/mcdfinder_development')
    # DataMapper.setup(:default, "mysql://root:amxdod@localhost/mcdfinder_production")
    DataMapper.setup(:default, {
     :adapter  => 'mysql',
     :host     => 'localhost',
     :username => 'root' ,
     :password => 'amxdod',
     :database => 'mcdfinder_production', 
     :socket => '/tmp/mysql.sock'
     })
     
    # DataMapper::Adapters::PostgresAdapter::SQL.module_eval do
    DataMapper::Adapters::MysqlAdapter::SQL.module_eval do
      def quote_name(name)
        if name.include? '('
          name
        else
          "`#{name[0, self.class::IDENTIFIER_MAX_LENGTH].gsub('`.`', '.')}`"
        end
      end
    end
end

