# FanController Project

## Overview
The **FanController** project is a Verilog-based digital design that simulates a fan controller system with various functionalities, including:

- **Fan speed control**
- **Battery monitoring**
- **Status indication** using a 7-segment display and a dual-color dot matrix

The project emphasizes a clear and organized **design methodology**, utilizing modular and hierarchical design techniques for clarity, scalability, and manageability.

## Design Methodology
This project follows a **Bottom-up Design** approach. The development begins by constructing fundamental building blocks, which are then systematically integrated into higher-level modules. Key methodologies include:

- **Design Abstraction**: Managing complexity through multiple levels of abstraction.
- **Modular Design**: Encapsulating each system feature (timing, debounce, fan control, etc.) in its own module.
- **Hierarchical Design Representation**: Structuring the project so that the top module, `FanController`, integrates all sub-modules.

## Project Hierarchy & Design Representation

### 1. Top-Level Module: `FanController`
**Purpose**: Manages overall system behavior by integrating various sub-modules.

**Components**:
- `Timer`: Handles timing signals (1s, 500ms, etc.)
- `Debounce`: Filters noise from user inputs
- `StateManager`: Manages fan's operational state (off, low, medium, high)
- `BatteryManager`: Monitors battery level and charging status
- `LEDControl`: Controls LED indicators for fan state and battery status
- `DotMatrixDisplay`: Generates patterns for the dual-color dot matrix
- `DynamicDotMatrix`: Manages multiplexing for the dual-color dot matrix
- `SevenSegmentDisplay`: Displays fan speed and battery level
- `DynamicDisplay3`: Controls dynamic scanning for the 7-segment display

### 2. Sub-Modules
Each sub-module is a self-contained unit responsible for a specific function in the system:

- **`Timer`**: Generates timing intervals for synchronous operations.
- **`Debounce`**: Cleans up button inputs to ensure noise-free transitions.
- **`StateManager`**: A finite state machine for fan speed control.
- **`BatteryManager`**: Monitors battery status.
- **`LEDControl`**: Provides visual feedback on system state.
- **`DotMatrixDisplay` & `DynamicDotMatrix`**: Control the dual-color dot matrix.
- **`SevenSegmentDisplay` & `DynamicDisplay3`**: Manage multiplexing for the 7-segment display.

## Design Abstraction
The system is abstracted at multiple levels:

- **System Level**: The `FanController` module oversees the entire system, abstracting away low-level implementation details.
- **Functional Level**: Each sub-module abstracts specific tasks like timing, state management, or display control.
- **Hardware Abstraction**: Inside each sub-module, hardware-specific details are encapsulated.

## Modular Design
The project’s emphasis on modularity provides several benefits:

- **Scalability**: New features can be added without altering existing code.
- **Maintainability**: Each module can be tested and debugged separately.
- **Reusability**: Modules are reusable for other projects.

## Bottom-up Design Process
### Building the Foundation
- **`Timer Module`**: Created first to generate periodic signals.
- **`Debounce Module`**: Implemented for reliable button input.
- **`Battery Management`**: Handles charging and battery depletion.

### Intermediate Layers
- **`StateManager Module`**: Manages fan state.
- **Display Modules**: Handle visual outputs (7-segment display and dot matrix).

### Integration
- Integrated modules into `FanController`.
- Tested the system iteratively for seamless component interaction.

## Managing Design Complexity
Design complexity is managed through **modular design** and **hierarchical organization**, allowing visualization at different levels of granularity. The use of Verilog constructs like `always` blocks and continuous assignments facilitates this process.

## Tools & Verification
The project relies on several tools for verification and implementation:

- **Simulation**: Verify functionality before hardware deployment.
- **Synthesis**: Check for timing constraints and resource usage.
- **Debugging**: Use debugging tools to ensure signal integrity and correct behavior.

## Conclusion
The FanController project is a comprehensive example of managing a complex digital system using **hierarchical and modular design**. The structured methodology ensures both simplicity and scalability, making the system adaptable for future enhancements.

---

**Note**: For more detailed technical information, please refer to the individual module files.

