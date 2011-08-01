require 'parslet'
module SQL
  module Parser
    class Statement < Parslet::Parser
      # At least one space character (space, tab, new line, carriage return)
      rule(:spaces) { match('\s').repeat(1) }
      rule(:lparen){ spaces? >> str('(') >> spaces?}
      rule(:rparen){ spaces? >> str(')') >> spaces?}
      rule(:spaces?){ spaces.maybe}
      rule(:digit) { match('[0-9]') }
      rule(:int){ digit.repeat(1).as(:int) }
      rule(:bool_not) { spaces >> (str('not') | str('NOT')).as(:not) >> spaces}

      rule(:float) do
        (str('-').maybe >> (
                str('0') | (match('[1-9]') >> digit.repeat)
              ) >> (
                str('.') >> digit.repeat(1)
              ) >> (
                match('[eE]') >> (str('+') | str('-')).maybe >> digit.repeat(1)
              ).maybe
            ).as(:float)
      end

      rule(:string) do
        (str('"') >> (str('\\') >> any | str('"').absent? >> any).repeat.as(:string) >> str('"')) |
         (str('\'') >> (str('\\') >> any | str('\'').absent? >> any ).repeat.as(:string) >> str('\''))
      end

      rule(:boolean_operator) do
        str('and') | str('or') | str('AND') | str('OR')
      end

      rule(:operator) do
        (str('!=') | str('like') | str('LIKE') | str('=') | str('<=') | str('>=') | str('<') | str('>')).as(:operator)
      end

      rule(:column) do
        match('[-_0-9a-zA-Z]').repeat.as(:column)
      end

      rule(:value) do
        spaces? >> (val | column) >> spaces?
      end

      rule(:val) do
        (string | int | float).as(:val)
      end

      rule(:entity) do
        bool_not.maybe >> (value.as(:lvalue) >> operator >> value.as(:rvalue))
      end

      rule(:statement) do
        (lparen >> (top | statement | entity) >> rparen) | entity
      end

      rule(:top) do
        statement.as(:lstatement) >> (boolean_operator.as(:boolean_operator) >> top.as(:rstatement)) | statement.as(:lstatement)
      end

      root(:top)
    end
  end
end
