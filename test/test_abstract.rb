require 'helper'

class TestAbstract < Test::Unit::TestCase

  def setup
    @abstract = SQL::Abstract.new
  end

  test "parse a simple condition" do
    assert_equal( {:"-and" => [{:"-=" => { :id => 1}}, {:"-like" => {:label => '%webo%'}}]}, @abstract.parse("id = 1 and label like '%webo%'"))
    assert_equal( {:"-and" => [{:"-=" => { :id => 1}}, {:"-like" => {:label => '%webo%'}}]}, @abstract.parse("((id = 1 )) and label like '%webo%'"))
  end

  test "parse a complex condition" do
    assert_equal( 
                 {
      :"-or" => [
        {:"-and" => [{:"-=" => { :id => 1}}, {:"-like" => {:label => '%webo%'}}]},
        {:"-and" => [{:"-!=" => { :id => 1}}, {:"-like" => {:label => '%api%'}}]}
    ]
    }, 
      @abstract.parse("(id = 1 AND label like '%webo%') OR (id !=1 and label like '%api%')")
                )
  end

  test "raise error when bad formatted sql" do
    assert_raise Parslet::ParseFailed do
      # No AND
      @abstract.parse("(id = 1 label like '%webo%')")
    end
    assert_raise Parslet::ParseFailed do
      @abstract.parse("label liike '%webo%'")
    end
    assert_raise Parslet::UnconsumedInput do
      @abstract.parse("id = 1 ET label like '%webo%'")
    end
    assert_raise Parslet::UnconsumedInput do
      @abstract.parse("(id = 1 AND label like '%webo%') OR (id !=1 and label like '%api%'")
    end
  end

end
