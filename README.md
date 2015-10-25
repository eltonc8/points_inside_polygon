# Pointers inside a polygon?
### A Ruby algorithm

This is a Ruby algorithm to check if a point is inside of a polygon. Please feel free to adapt it to your applications' needs.

#### Notes about the implementation

##### Strategy / algorithm
Draw a line between the point (x, y) ad (x, -infinity). The number of edge crossing should be odd if the point lines within the polygon.

##### Definition of edge cases
A point is considered within the polygon if it lies on the edge or a point defined as the vertex of the polygon.

##### Other conditions
* Concavity - the algorithm tolerates concave polygons.
 * the algorithm handles internal corners and edges.
* Edge crossings - the algorithm should tolerate a polygon whose edges cross themselves, but this was **not** originally intended nor tested. The points at which edges cross are considered within the polygon, as defined by the above edge case.

##### RSpec
46 tests are provided to check the robustness of the code. Please let me know if other edge cases are found for which the algorithm fails.
