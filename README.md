# SPI-RAM-interface
SPI Slave with RAM and testbench in Verilog
# SPI Slave with MOSI Register and Testbench
Verilog-based SPI Slave interface with Single Port Asynchronous RAM for command/data exchange

## 📌 Overview
This project implements an **SPI Slave** module in Verilog that:
- Stores data from the MOSI line into an internal register.
- Supports `WRITE`, `READ_ADDR`, and `READ_DATA` states.
- Sends data to the master via MISO when requested.
- Includes a testbench to simulate two full SPI transactions.

The design is state-machine-based and parameterized for flexibility.

---
## Block Diagram
![Block Diagram](images/SPI-RAM_blockDiagrams.JPEG)

## 🛠 Features
- **Finite State Machine (FSM)** for SPI operations:
  - `IDLE`
  - `CHK_CMD`
  - `WRITE`
  - `READ_ADDR`
  - `READ_DATA`
- 10-bit receive register for MOSI data.
- Transmit capability through MISO.
- Transaction-ready signal (`rx_valid`).
- Testbench provided for simulation.

---

## 📂 File Structure
├── SPI_slave.v # SPI slave module
├── MOSI_register.v # Dedicated register to store MOSI data
├── tb_SPI_slave.v # Testbench for two transactions
├── README.md # Project documentation (this file)

---

## 🧪 Testbench Details
The provided testbench simulates:
1. A `WRITE` transaction from master to slave.
2. A `READ` transaction to retrieve data from slave.

Waveforms can be analyzed with simulation tools like:
- **ModelSim**
- **Vivado**

---

## 🚀 How to Run
1. Open your Verilog simulation tool.
2. Compile all `.v` files.
3. Run `SPI_wrapper_tb.v` as the top module.
4. Inspect waveforms to verify SPI protocol timing.

---

## 📜 License
This project is released under the **MIT License**.  
You are free to use, modify, and distribute it with attribution.

---

## ✍ Author
**Mariam Hossam**  
GitHub: [Mariam-hossam9](https://github.com/Mariam-hossam-9)
