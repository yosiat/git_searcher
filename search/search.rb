require "tire"


PER_PAGE = 10
PAGE = 0

s = Tire.search '_all', :page => 1, :per_page=> 3 do
  query do
    # string "language:C#"
    # string "path:JsonArrayAttributeTests.cs"
    all
  end

  size PER_PAGE
  from PAGE * PER_PAGE
end

s.results.each do |r|
	puts r.path
end