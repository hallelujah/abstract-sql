# Abstract SQL

You ca use this project to transform a SQL string into a Perl SQL::Abstract statement format (as a Hash)

## Usage

All you need to do is to add this line in your Gemfile

      gem 'abstract-sql'

Then use it like this :

    statement = "(id = 1 AND label like '%webo%') OR (id !=1 and label like '%api%')"
    abstract = SQL::Abstract.new
    abstract.parse statement
    #=> {
          :"-or"=>
            [{:"-and"=>[{:"-="=>{:id=>1}}, {:"-like"=>{:label=>"%webo%"}}]},
             {:"-and"=>[{:"-!="=>{:id=>1}}, {:"-like"=>{:label=>"%api%"}}]}
            ]
        }


