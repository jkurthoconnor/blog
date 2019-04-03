require "redcarpet"
require "pygments"

class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language="ruby")
    Pygments.highlight(code, :lexer => language)
  end
end

