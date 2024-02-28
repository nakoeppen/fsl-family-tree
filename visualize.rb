require 'ruby-graphviz'
require_relative 'fslmem.rb'

# Create a new graph
g = GraphViz.new( :G, :type => :digraph )

b1 = FSLMem.new(1140, "Nicholas Koeppen", "Spring 2022", nil, "He is cool")
b2 = FSLMem.new(1145, "Matthew Dembny", "Spring 2023", b1, "He is also cool")
b3 = FSLMem.new(9999, "Dimitri", "Fall 2023", b2, "Cool dude.")

edges = [b1, b2, b3].map{|b| g.add_nodes(b.getName())}

g.add_edges(edges[0], edges[1])
g.add_edges(edges[1], edges[2])

# Generate output image
g.output( :png => "output.png" )
