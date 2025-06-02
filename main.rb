require 'set'
require 'matrix'

# SOLVER FUNCTIONS
=begin
Recursive TSP function:
Arguments:
  i         - current city index (0-based)
  remaining - Set of unvisited city indices
  adj       - adjacency matrix (Matrix of floats; Float::INFINITY for no edge)
  start     - starting city index (0-based)
  memo      - hash for memoization, keys are [i, remaining.to_a.sort], values are min cost
Returns:
  Minimum cost to start at city i, visit every city in 'remaining', and return to 'start'.
=end
def tsp_cost(i, remaining, adj, start, memo)
  # Base case: no cities left to visit → return cost to go back to start
  if remaining.empty?
    return adj[i, start]
  end

  # Build a memo key from current state
  key = [i, remaining.to_a.sort]
  return memo[key] if memo.key?(key)

  min_cost = Float::INFINITY

  # Try each possible next city j in 'remaining'
  remaining.each do |j|
    # If there's no edge i → j, skip
    next if adj[i, j] == Float::INFINITY

    # Build new set without j
    next_remaining = remaining.dup
    next_remaining.delete(j)

    # Recurse: cost from i → j + optimal cost from j with next_remaining
    cost_to_j = adj[i, j] + tsp_cost(j, next_remaining, adj, start, memo)
    min_cost = cost_to_j if cost_to_j < min_cost
  end

  memo[key] = min_cost
  return min_cost
end

=begin
Reconstruct the optimal path given the completed memo table:
Arguments:
  i         - current city index (0-based)
  remaining  - Set of unvisited city indices
  adj       - adjacency matrix
  start     - starting city index
  memo      - hash filled by tsp_cost
Returns:
  Array of city indices (0-based) representing the path from i through all
  remaining cities and finally back to start.
=end
def tsp_path(i, remaining, adj, start, memo)
  # Base case: no cities left → return [start]
  if remaining.empty?
    return [start]
  end

  min_cost = Float::INFINITY
  best_next = nil

  # Determine which next city j gives the minimum total cost
  remaining.each do |j|
    next if adj[i, j] == Float::INFINITY

    next_remaining = remaining.dup
    next_remaining.delete(j)

    total_cost = adj[i, j] + tsp_cost(j, next_remaining, adj, start, memo)
    if total_cost < min_cost
      min_cost = total_cost
      best_next = j
    end
  end

  # If best_next is nil, no valid continuation → return empty path
  return [] if best_next.nil?

  # Recursively build the remainder of the path
  next_remaining = remaining.dup
  next_remaining.delete(best_next)
  return [best_next] + tsp_path(best_next, next_remaining, adj, start, memo)
end

# MAIN PROGRAM EXECUTION
if __FILE__ == $0
  puts <<~TITLE

  ╔══════════════════════════════════════════════╗
  ║                                              ║
  ║      Traveling Salesman Solver using DP      ║
  ║               (by 15223011)                  ║
  ║                                              ║
  ╚══════════════════════════════════════════════╝

  TITLE

  print "Input the test file name (e.g., test1.txt): "
  filename = "tests/" + gets.chomp

  # Read adjacency matrix from file, converting "inf" → Float::INFINITY
  raw_rows = []
  begin
    File.open(filename).each_line do |line|
      row = line.split.map do |token|
        token.strip.downcase == "inf" ? Float::INFINITY : token.to_f
      end
      raw_rows << row
    end
  rescue Errno::ENOENT
    puts "Error: File '#{filename}' not found."
    exit
  end

  n = raw_rows.size
  raw_rows.each_with_index do |row, i|
    if row.size != n
      puts "Error: Line #{i + 1} does not have #{n} entries."
      exit
    end
  end

  # Build a Matrix from the raw 2D array
  # Matrix.[] expects rows as separate arguments; splat the array of rows.
  adj_matrix = Matrix.rows(raw_rows)

  # Print the input matrix in a formatted table
  puts "\nInput matrix:"
  print "     |"
  (1..n).each { |j| print sprintf(" %5d |", j) }
  puts
  print "-----+" + ("-------+" * n) + "\n"
  (1..n).each do |i|
    print sprintf(" %3d |", i)
    (1..n).each do |j|
      val = adj_matrix[i - 1, j - 1]
      display = (val == Float::INFINITY) ? "inf" : sprintf("%.1f", val)
      print sprintf(" %5s |", display)
    end
    puts
  end

  # Prompt for starting node
  puts "\nEnter the starting city (1 to #{n}):"
  user_input = gets.chomp.to_i
  if user_input < 1 || user_input > n
    puts "Error: starting node must be between 1 and #{n}."
    exit
  end
  start = user_input - 1

  # Build the initial set of remaining cities (all except start)
  remaining = Set.new((0...n).to_a - [start])
  memo = {}

  # Compute the minimum tour cost
  min_cost = tsp_cost(start, remaining, adj_matrix, start, memo)

  if min_cost == Float::INFINITY
    puts "\nNo valid tour exists (cost is infinite)."
    exit
  end

  # Reconstruct the full tour path (0-based indices)
  path_nodes = [start] + tsp_path(start, remaining, adj_matrix, start, memo)
  # Convert to 1-based indices for display
  display_path = path_nodes.map { |city| city + 1 }

  puts "\n --------- SOLUTION ---------"
  puts "Tour path: " + display_path.join(" → ")

  # Print detailed tour sequence with individual edge costs
  puts "\nTour details:"
  (0...display_path.size - 1).each do |i|
    from = display_path[i]
    to   = display_path[i + 1]
    cost = adj_matrix[from - 1, to - 1]
    puts "#{i + 1}) #{from} → #{to}: #{'%.1f' % cost}"
  end

  puts "\nTotal tour cost: #{'%.1f' % min_cost}"
end
