# 🚀 SPI Slave with Single Port RAM

This project implements a fully functional **SPI Slave module** integrated with a **Single Port RAM**, capable of complete **read and write operations** through an SPI interface. The design is written in Verilog HDL, verified using a **self-checking testbench**, and optimized using three state encoding methods: **Sequential**, **One-hot**, and **Gray**.

---

## 🧩 Features

- SPI Slave Interface:
  - Supports `MOSI`, `MISO`, `SS_n`, `clk`
- Integrated Single-Port RAM (256-byte depth)
- FSM-based SPI protocol with 4 distinct commands
- Self-checking testbench (repeats 2000 times)
- Timing comparison between encoding styles
- Waveform visualization and RTL/Synthesis/Implementation reports

---

## 📁 Project Structure

| File/Folder          | Description                                      |
|----------------------|--------------------------------------------------|
| `SPI_Wrapper.v`      | Top-level module integrating SPI logic and RAM  |
| `SPI_Protocol.v`     | FSM handling SPI command decoding and control   |
| `Single_Port_RAM.v`  | RAM module with separate read/write pointers     |
| `SPI_Wrapper_Tb.v`   | Testbench with full transaction coverage         |
| `waveforms/`         | Screenshots of simulated waveforms               |
| `constraints/`       | Constraints file with debug core included        |
| `report/`            | Full documentation and synthesis results         |
| `do_files/`          | Simulation script and signal display setup       |

---

## 🔄 SPI Protocol Phases

### 1. Write Address
- Send command `00`
- Transfer 8-bit address

### 2. Write Data
- Send command `01`
- Transfer 8-bit data to be written

### 3. Read Address
- Send command `10`
- Provide address to read from

### 4. Read Data
- Send command `11`
- Slave sends back stored data



## ✅ Testbench Overview

- Repeats 2000 complete SPI operations
- Checks that transmitted data on MISO matches expected memory content
- Stops simulation if any error occurs
- Asserts `tx_valid` signal for 8 exact clock cycles using a counter


## 📊 Encoding Comparison

| Encoding     | Setup WNS (ns) | Hold WHS (ns) | Selected |
|--------------|----------------|----------------|----------|
| Sequential   | 6.478          | 0.101          | ❌       |
| One-hot      | 6.822          | 0.055          | ❌       |
| **Gray**     | **6.973**      | **0.101**      | ✅ Best |

> **Gray encoding** offers the best setup and hold slack, supporting the highest operating frequency.


## 🛠 Tools Used

- **Simulation**: ModelSim / Questa
- **Synthesis & Implementation**: Xilinx Vivado
- **Language**: Verilog HDL
- **Target Device**: FPGA (with timing constraints)


## 🚦 How to Run

1. Compile all `.v` files in ModelSim or Vivado
2. Load the provided `do` file to view waveforms
3. Run simulation and verify output
4. Synthesize using Vivado and analyze reports
5. Compare timing results for encoding methods


## 👤 Author

- **Name**: Mohamed Shaban Moussa  
- **Email**: [mohamedmouse066@gmail.com](mailto:mohamedmouse066@gmail.com)  
- **LinkedIn**: [mohamed-s-moussa](https://www.linkedin.com/in/mohamed-s-moussa-ba0993285/)  
- **GitHub**: [SPI-Slave-with-Single-Port-RAM](https://github.com/mohamedSmoussa/SPI-Slave-with-Single-Port-RAM-)
