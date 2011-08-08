require 'parslet'
module SQL
  module Transform
    class Statement < Parslet::Transform
      rule(:val => simple(:x)){ x }
      rule(:val =>{:float => simple(:x)}){ String(x).to_f }
      rule(:val =>{:int => simple(:x)}){ String(x).to_i }
      rule(:val =>{:string => simple(:x)}){ String(x) }
      # rule(:boolean_operator => simple(:x)){{ :boolean_operator =>  String(x).downcase.to_sym }}
      
      rule(:lvalue => {:column => simple(:x) }, :operator => simple(:op), :rvalue => {:column => simple(:z)}) do 
        { String(x).to_sym => { operator(op) => String(z).to_sym } } 
      end

      rule(:lvalue => {:column => simple(:x) }, :operator => simple(:op), :rvalue => simple(:z) ) do
        {String(x).to_sym => { operator(op)  => z } } 
      end
      
      rule(:lvalue => simple(:x) , :operator => simple(:op), :rvalue => {:column => simple(:z)}) do
        { String(z).to_sym => { operator(op) => x } } 
      end

      # Very simple criterion
      rule({:lstatement => subtree(:l)}) do
        l
      end

      # Statement right or left without right leaf
      rule(:lstatement => { :lstatement => subtree(:y) })do
        {:lstatement => y } 
      end

      rule(:rstatement => { :lstatement => subtree(:y) })do
        {:rstatement => y} 
      end

      rule({:lstatement=>{:lstatement=> subtree(:l)}, :boolean_operator => simple(:op), :rstatement=>{:lstatement => subtree(:r)}}) do 
        {:lstatement => l, :boolean_operator => op, :rstatement => r} 
      end

      # Statement right or left without right leaf and a boolean operator
      rule(:lstatement => { :lstatement => subtree(:y) }) do
        {:lstatement => y } 
      end

      rule(:rstatement => { :lstatement => subtree(:y) }) do
        {:rstatement => y} 
      end

      rule({:lstatement => subtree(:l), :boolean_operator=> simple(:op), :rstatement=>{:lstatement=>subtree(:r)}}) do 
        {:lstatement => l, :boolean_operator => operator(op), :rstatement => r} 
      end

      rule({:rstatement => subtree(:r), :boolean_operator=> simple(:op), :lstatement=>{:lstatement=>subtree(:l)}}) do
        {:lstatement => l, :boolean_operator => operator(op), :rstatement => r} 
      end

      rule(:boolean_operator => simple(:op), :lstatement => subtree(:l), :rstatement => subtree(:r) ) do 
        {operator(op) => [l, r] } 
      end

      rule(:not => simple(:n), :lvalue=> subtree(:l), :operator=> simple(:op), :rvalue=> subtree(:r)) do
        {bool(n) => {:lvalue => l, :operator => op, :rvalue => r}}
      end


    end
  end
end

class Parslet::Pattern::Context
  def operator(op)
    if op.is_a?(Symbol)
      op
    else
      ( "-" + String(op) ).downcase.to_sym
    end
  end

  def bool(n)
    if (b = String(n).downcase) == 'not' 
      operator('not_bool') 
    else
      n
    end
  end

end
