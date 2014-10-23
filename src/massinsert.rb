#!/usr/bin/env ruby

# This code is derived from
# https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/
#
# The tests are based on the article. The surrounding code which supports
# the testing allows the code in the article to be executed. Specifically,
# we're running ActiveRecord without the full Rails stack.

require 'active_record'
require 'active_support'
require 'logger'
require 'rspec'
require 'pry-nav'

require './connection.rb'
require './migrations.rb'
require './user_node_score.rb'

TIMES = 500 # 1000
CONN = ActiveRecord::Base.connection

def do_inserts
    TIMES.times { UserNodeScore.create(:user_id => 1, :node_id => 2, :score => 3) }
end

def raw_sql
    TIMES.times { CONN.execute "INSERT INTO `user_node_scores` (`score`, `updated_at`, `node_id`, `user_id`) VALUES(3.0, '2009-01-23 20:21:13', 2, 1)" }
end

def mass_insert
    inserts = []
    TIMES.times do
        inserts.push "(3.0, '2009-01-23 20:21:13', 2, 1)"
    end
    sql = "INSERT INTO user_node_scores (score, updated_at, node_id, user_id) VALUES #{inserts.join(", ")}"
    #puts sql
    
    execute_result = CONN.execute sql
    puts execute_result.class
    puts execute_result.inspect
end

def mass_insert_connection_quote
    inserts = []
    TIMES.times do
        inserts.push "(3.0, #{CONN.quote("2009-01-23 20:21:13")}, 2, 1)"
    end
    sql = "INSERT INTO user_node_scores (score, updated_at, node_id, user_id) VALUES #{inserts.join(", ")}"
    #puts sql
    
    execute_result = CONN.execute sql
    puts execute_result.class
    puts execute_result.inspect
    #insert_result = CONN.insert sql
    #puts insert_result.class
    #puts insert_result
end

# Another way to do bulk loading from
# http://stackoverflow.com/questions/15317837/bulk-insert-records-into-active-record-table

=begin
def bulk_load
  batch,batch_size = [], 1_000 
  CSV.foreach("/data/new_products.csv", :headers => true) do |row|
    batch << Product.new(row)

    if batch.size >= batch_size
      Product.import batch
      batch = []
    end
  end
  Product.import batch
end
=end

def activerecord_extensions_mass_insert(validate = true)
    columns = [:score, :node_id, :user_id]
    values = []
    TIMES.times do
        values.push [3, 2, 1]
    end

    UserNodeScore.import columns, values, {:validate => validate}
end


puts "Testing various insert methods for #{TIMES} inserts\n"
puts "ActiveRecord without transaction:"
puts base = Benchmark.measure { do_inserts }

puts "ActiveRecord with transaction:"
puts bench = Benchmark.measure { ActiveRecord::Base.transaction { do_inserts } }
puts sprintf("  %2.2fx faster than base", base.real / bench.real)

puts "Raw SQL without transaction:"
puts bench = Benchmark.measure { raw_sql }
puts sprintf("  %2.2fx faster than base", base.real / bench.real)

puts "Raw SQL with transaction:"
puts bench = Benchmark.measure { ActiveRecord::Base.transaction { raw_sql } }
puts sprintf("  %2.2fx faster than base", base.real / bench.real)

puts "Single mass insert:"
puts bench = Benchmark.measure { mass_insert }
puts sprintf("  %2.2fx faster than base", base.real / bench.real)

puts "Single mass insert with connection quoting:"
puts bench = Benchmark.measure { mass_insert_connection_quote }
puts sprintf("  %2.2fx faster than base", base.real / bench.real)


=begin
puts "ActiveRecord::Extensions mass insert:"
puts bench = Benchmark.measure { activerecord_extensions_mass_insert }
puts sprintf("  %2.2fx faster than base", base.real / bench.real)

puts "ActiveRecord::Extensions mass insert without validations:"
puts bench = Benchmark.measure { activerecord_extensions_mass_insert(true)  }
puts sprintf("  %2.2fx faster than base", base.real / bench.real)
=end
