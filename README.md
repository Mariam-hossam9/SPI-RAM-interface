# SPI-RAM Interface

This project implements an SPI Slave module connected to a Single-Port Asynchronous RAM.  
It enables read/write operations via SPI protocol and stores/retrieves data from RAM.

---

## Features
- SPI Slave functionality (MISO/MOSI/SS)
- Single-Port Asynchronous RAM storage
- Separate Read and Write address handling
- Modular and reusable Verilog code

---

## Block Diagram
Below is the block diagram of the SPI-RAM interface system:

![Block Diagram](images/SPI-RAM_blockDiagram.png)

---

## Waveform
Sample simulation waveform showing SPI transactions and RAM operations:

![Waveform](images/Waveform.png)

---
## Finite State Machine (FSM)

The SPI Slave module is implemented as a finite state machine (FSM) to control data flow between the SPI interface and the RAM module.  
It operates in **five main states**:

1. **IDLE** – Waits for the Slave Select (`SS_n`) signal to go low, indicating the start of communication.
2. **CHK_CMD** – Receives and interprets the command bits from MOSI.
3. **WRITE** – Writes incoming data to the RAM.
4. **READ_ADDR** – Captures the address from which data will be read.
5. **READ_DATA** – Sends requested data back to the SPI master via MISO.

### FSM State Diagram
![FSM Diagram](images/SPI-RAM_FSM.png)

---

### State Transition Summary
| Current State | Condition                          | Next State    |
|---------------|------------------------------------|--------------|
| IDLE          | `SS_n == 0`                        | CHK_CMD      |
| CHK_CMD       | bit count complete, command decode | WRITE / READ_ADDR / READ_DATA |
| WRITE         | `SS_n == 1`                        | IDLE         |
| READ_ADDR     | `SS_n == 1`                        | IDLE         |
| READ_DATA     | Data sent                          | IDLE         |

---

## File Descriptions
- **`SPI_SLAVE.v`** → Verilog module for SPI slave communication.
- **`Single_port_Async_RAM.v`** → Verilog module for single-port asynchronous RAM.
- **`README.md`** → Project documentation.
- **`images/`** → Contains diagrams and waveform images.

---

## How to Run Simulation
1. Open your preferred HDL simulator (ModelSim, Vivado, etc.).
2. Add both `SPI_SLAVE.v` and `Single_port_Async_RAM.v` to the project.
3. Include your testbench file.
4. Compile and simulate to observe waveforms.

---

## Author
**Mariam Hossam**  
[GitHub Profile](https://github.com/Mariam-hossam9)

---
