require "abstract-sql/version"
require "abstract-sql/parser/statement"
require "abstract-sql/transform/statement"

module SQL
  class Abstract

    attr_reader :parser, :transformer

    def initialize
      @parser = Parser::Statement.new
      @transformer = Transform::Statement.new
    end

    def parse(sql)
      tree = @parser.parse(sql)
      while tree != (t = @transformer.apply(tree) )
        tree = t
      end
      t
    end
  end
end
