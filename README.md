# Traveling Salesman Problem Solver

This program solves the **Traveling Salesman Problem (TSP)** using dynamic programming with memoization. It reads an adjacency matrix from a text file, computes the shortest possible tour visiting each city exactly once and returning to the starting city, and outputs the tour path and total cost.

This program implements a recursive function:
- State: f(i, S)
- Base Case: f(i, ∅) = c[i][1]
- Recursive Case: f(i, S) = min { c[i][j] + f(j, S - {j}) | j ∈ S }


## Project Structure
```
root/
├── tests/          # Test files containing adjacency matrices (.txt)
├── test_results/   # Test result screenshots
└── main.rb         # Main Ruby script for the TSP solver
└── README.md
```

## Input File Format
A test `.txt` file must follow this structure (e.g., `tests/test1.txt`):
```
0 10 15 20
5 0 9 10
6 13 0 12
8 8 9 0
```
- Each line represents a row in the adjacency matrix.
- Values are space-separated numbers or `inf` (for no edge).
- The matrix must be square (same number of rows and columns).

## How to Run

### Dependencies
- **Ruby**
  - Required standard libraries: `set` and `matrix` (included with Ruby).

### Running the Program
1. **Ensure Ruby is Installed**:
   ```bash
   ruby --version
   ```
   If not installed, download and install Ruby from [ruby-lang.org](https://www.ruby-lang.org/).

2. **Prepare a Test File**:
   - Place your adjacency matrix file (e.g., `test1.txt`) in the `tests/` directory.
   - Example content for `tests/test1.txt`:
     ```
      0 10 15 20
      5 0 9 10
      6 13 0 12
      8 8 9 0
     ```

3. **Run the Program**:
   - Navigate to the project root directory.
   - Execute the Ruby script:
     ```bash
     ruby tsp.rb
     ```
   - Follow the prompts:
     - Enter the test file name (e.g., `test1.txt`).
     - Enter the starting city number (1-based, e.g., `1` for city 1).

   **Example Interaction**:
   ```
   Input the test file name (e.g., test1.txt): test1.txt

   Input matrix:
        |     1 |     2 |     3 |     4 |
   -----+-------+-------+-------+-------+
      1 |   0.0 |  10.0 |  15.0 |  20.0 |
      2 |   5.0 |   0.0 |   9.0 |  10.0 |
      3 |   6.0 |  13.0 |   0.0 |  12.0 |
      4 |   8.0 |   8.0 |   9.0 |   0.0 |

   Enter the starting city (1 to 4):
   1
   ```

## Sample Output
```
 --------- SOLUTION ---------
Tour path: 1 → 2 → 4 → 3 → 1

Tour details:
1) 1 → 2: 10.0
2) 2 → 4: 10.0
3) 4 → 3: 9.0
4) 3 → 1: 6.0

Total tour cost: 35.0
```

## Input & Output Screenshots
![test_result1](https://github.com/KalengBalsem/Tantangan_15223011/blob/eb23004ee20800eca0ada7e401d70b6a244368f2/test_results/test_result1.png)

![test_result2](https://github.com/KalengBalsem/Tantangan_15223011/blob/eb23004ee20800eca0ada7e401d70b6a244368f2/test_results/test_result2.png)

![test_result3](https://github.com/KalengBalsem/Tantangan_15223011/blob/eb23004ee20800eca0ada7e401d70b6a244368f2/test_results/test_result3.png)

![test_result4](https://github.com/KalengBalsem/Tantangan_15223011/blob/eb23004ee20800eca0ada7e401d70b6a244368f2/test_results/test_result4.png)

## Author
| Name           | ID       | Class |
|----------------|----------|-------|
| Asybel B.P. Sianipar | 15223011 | K1   |
