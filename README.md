# Matrix Multiplication using Systolic Array

This project implements a matrix multiplication algorithm using a **Systolic Array Architecture**. The design is modular and supports matrices of any size, making it adaptable and scalable for various applications. It features an efficient interface between the matrices' memory and the systolic array, ensuring smooth data flow and optimal performance.

## Features
- **Modular Design**: Supports any matrix size through a flexible architecture.
- **Memory Interface**: Provides an optimized connection between the matrices' memory and the systolic array, minimizing data transfer bottlenecks.
- **Parallel Processing**: Takes advantage of the parallelism in the systolic array to achieve faster computations.
- **Scalability**: Can be easily scaled for larger matrix sizes by adding more processing elements (PEs).

## Project Structure
- `src/`: Contains the source code for the systolic array and memory interface.
- `sim/`: Contains testbenches for validating the design.
- `.png/`: Results from the simulations showing the performance.
- `.mem/`: memory files for input matrices.

## How It Works
The systolic array consists of interconnected **Processing Elements (PEs)** arranged in a grid structure. Each PE performs multiplication and accumulation. The memory interface manages the flow of matrix data into the array and stores the results.

- **Pipelined Architecture**: The design is pipelined, meaning that matrix elements flow continuously through the array, allowing for efficient computation.
- **Data Flow**: Input matrices are fed into the systolic array through the memory interface, which handles the sequencing and ensures that the results are stored correctly.

## Design Highlights
- **Efficient Memory Usage**: The interface optimizes the movement of data between memory and the systolic array, reducing latency.
- **Flexible Design**: Can handle any matrix size by adjusting the number of PEs and interface parameters.

## Simulation and Testing
To verify the design, testbenches have been created for various matrix sizes. The system has been simulated using different tools to check for correctness and performance.

To run simulations:
1. Navigate to the `sim/` folder.
2. Use your simulation tool (e.g., ModelSim, Vivado) to compile and run the testbenches.


## Getting Started
To get started with the project:

1. Clone the repository:
   ```bash
   git clone https://github.com/moateff/matrix-multiplication-systolic-array.git
