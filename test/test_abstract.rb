require 'helper'

class TestAbstract < Test::Unit::TestCase

  def setup
    @abstract = SQL::Abstract.new
  end


  test "parse very simple condition" do
    assert_equal({ :criterion_13 => {:"-<=" => 8} }, @abstract.parse("criterion_13 <= 8"))
    assert_equal({ :criterion_13 => {:"-<=" => 8} }, @abstract.parse("(criterion_13 <= 8)"))
  end

  test "parse a simple condition" do
    assert_equal( {:"-and" => [{:id => { :"-=" => 1}}, {:label => {:"-like" => '%webo%'}}]}, @abstract.parse("id = 1 and label like '%webo%'"))
    assert_equal( {:"-and" => [{:id => { :"-=" => 1}}, {:label => {:"-like" => '%webo%'}}]}, @abstract.parse("((id = 1 )) and label like '%webo%'"))
    assert_equal({:"-and" => [{ :criterion_13 => {:"-<=" => 8} },{ :age => {:"->=" => 5} }]}, @abstract.parse("(criterion_13 <= 8) and age >= 5"))
  end

  test "parse a complex condition" do
    assert_equal( 
                 {
      :"-or" => [
        {:"-and" => [{:id => { :"-=" => 1}}, {:label => {:"-like" => '%webo%'}}]},
        {:"-and" => [{:id => { :"-!=" => 1}}, {:label => {:"-like" => '%api%'}}]}
    ]
    }, 
      @abstract.parse("(id = 1 AND label like '%webo%') OR (id !=1 and label like '%api%')")
                )
  end

  test "Very complex condition" do
    assert_equal(
      {
      :"-and" => [
        { :"-or" => [ {:criterion_7 => {:"->=" => 8}}, {:criterion_1 => {:"-<" => 8}} ] },
        { :"-or" => [ {:segment_1 => {:"-<" => 4}}, {:"-not_bool" => { :segment_2 => {:"-<" => 1} }}] }
    ]
    },
      @abstract.parse("( criterion_7 >= 8 or criterion_1 < 8 ) and ( segment_1 < 4 or not segment_2 < 1 )")
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
