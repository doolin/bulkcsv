# Bulk loading CSV files

# Two main techniques

1. Rails-native
2. "Database" native

# Rails-native csv import

Read in csv file, create ActiveRecord objects, save those objects.

### Benefits

* easy
* Not difficult to create associations on import

### Disadvantages

* slow

# Database native

Use the database tools for directly importing.

### Benefits

* Fast

### Disadvantages

* Fiddly to get tables auto-sequenced, etc.
* Much more difficult to preserve associations.

# Some brief notes

Nothing to see here yet.

# Links


* [Mass inserting coffeepower style](https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/), a bit dated, still useful.
* [ActiveRecord connection insert](http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/DatabaseStatements.html#method-i-insert) is *fast*, but only returns the last auto-generated id.
