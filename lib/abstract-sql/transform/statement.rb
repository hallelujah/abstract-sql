require 'parslet'
module SQL
  module Transform
    class Statement < Parslet::Transform
      rule(:val => simple(:x)){ x }
      rule(:val =>{:float => simple(:x)}){ String(x).to_f }
      rule(:val =>{:int => simple(:x)}){ String(x).to_i }
      rule(:val =>{:string => simple(:x)}){ String(x) }
      # rule(:boolean_operator => simple(:x)){{ :boolean_operator =>  String(x).downcase.to_sym }}
      rule(:lvalue => {:column => simple(:x) }, :operator => simple(:op), :rvalue => {:column => simple(:z)}){ {operator(op) => { String(x).to_sym => String(z).to_sym } } }
      rule(:lvalue => {:column => simple(:x) }, :operator => simple(:op), :rvalue => simple(:z) ){ {operator(op) => { String(x).to_sym => z } } }
      rule(:lvalue => simple(:x) , :operator => simple(:op), :rvalue => {:column => simple(:z)}){ {operator(op) => { String(z).to_sym => x } } }

      # Statement right or left without right leaf
      rule(:lstatement => { :lstatement => subtree(:y) }){ {:lstatement => y }}
      rule(:rstatement => { :lstatement => subtree(:y) }){ {:rstatement => y}}

      rule({:lstatement=>{:lstatement=> subtree(:l)},
           :boolean_operator => simple(:op),
           :rstatement=>{:lstatement => subtree(:r)}}) do {:lstatement => l, :boolean_operator => op, :rstatement => r} end

      # Statement right or left without right leaf and a boolean operator
      rule(:lstatement => { :lstatement => subtree(:y) }){ {:lstatement => y }}
      rule(:rstatement => { :lstatement => subtree(:y) }){ {:rstatement => y}}

      rule({:lstatement => subtree(:l),
       :boolean_operator=> simple(:op),
       :rstatement=>{:lstatement=>subtree(:r)}}) do {:lstatement => l, :boolean_operator => operator(op), :rstatement => r} end

      rule({:rstatement => subtree(:r),
       :boolean_operator=> simple(:op),
       :lstatement=>{:lstatement=>subtree(:l)}}) do {:lstatement => l, :boolean_operator => operator(op), :rstatement => r} end


      rule(:boolean_operator => simple(:op), :lstatement => subtree(:l), :rstatement => subtree(:r) ) { {operator(op) => [l, r] } }


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

end
