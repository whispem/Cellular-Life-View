# 🧫 Cellular Life Simulation  
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)  
[![Platform](https://img.shields.io/badge/iOS-17.0-brightgreen.svg)](https://developer.apple.com/ios/)  
[![Framework](https://img.shields.io/badge/SwiftUI-Framework-blueviolet.svg)](https://developer.apple.com/xcode/swiftui/)  
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)  

**CellularLifeView** is an **interactive SwiftUI simulation** that visualizes a miniature, evolving **cellular ecosystem** — where virtual cells move, divide, merge, and fade dynamically in a vibrant biological environment.  
It’s an artistic exploration of **computational biology**, **emergent behavior**, and **real-time visualization** in iOS.  

---

## 🔹 Features

- **Autonomous Cellular Simulation**  
  - Cells **move**, **age**, **divide**, and **merge** dynamically  
  - Each cell maintains energy, velocity, and life cycle state  

- **Real-Time Metrics Dashboard**  
  - Active cells count  
  - Generational evolution tracking  
  - Total births & elapsed simulation time  
  - Adjustable simulation speed  

- **Biological Background System**  
  - Animated gradient waves and particle flow  
  - Dynamic visual response to the number of living cells  

- **Interactive UI Controls**  
  - Toggle visibility of live metrics  
  - Smooth transitions and fluid animations powered by SwiftUI  

- **Immersive Visual Design**  
  - Pulsating gradients and glowing energy halos  
  - Organic color mutation & cell blending  
  - Ultra-thin material effects and neon-inspired glow  

---

## 🎯 Key Components

- **`CellularLifeView`** – Main SwiftUI structure managing simulation logic, metrics, and visuals  
- **`Cell`** – Data model representing a biological unit (state, energy, color, motion, age)  
- **`CellView`** – Responsible for rendering a living cell with layered gradients, pulsation, and glow  
- **`BiologicalBackground`** – Procedural animated background mimicking microscopic fluid motion  
- **`BiologicalStatusCard`** & **`CellMetricCard`** – Custom UI components for biological stats and metrics  

---

## 🎨 Design & Tech Stack

- **SwiftUI** – Declarative and reactive UI framework  
- **Core Animation** – Smooth transitions and energy pulsations  
- **GeometryReader** – Responsive positioning within dynamic layouts  
- **Canvas API** – For particle and waveform-based background rendering  
- **Material Design Effects** – Subtle depth, glow, and reflection to enhance immersion  

---

## 🧠 Behind the Simulation

The system models life-like behavior through probabilistic algorithms and emergent dynamics:

- **Cell Division**: Triggered when energy and age thresholds align.  
- **Cell Merging**: Occurs when cells collide under random probability.  
- **Energy Decay**: Drives the natural death and fading of older cells.  
- **Color Mutation**: Introduces variety and unpredictability in generations.  

Each frame is smoothly animated using **SwiftUI’s reactive state updates**, producing a continuous biological rhythm on-screen.

---

## 👩🏻‍💻 About me

Hi, I’m **Emilie (Em’)** 👋🏼  
I design and code experiences that blend **art, science, and technology** — from interactive data visualizations to creative SwiftUI experiments.  
My goal is to push the boundaries of what feels “alive” in digital environments.

- **Skills**: Swift, SwiftUI, UI/UX, Creative Coding, Motion Design  
- **Education**: Apple Foundation Program, Swift Certification  
- **Interests**: Computational Art, Generative Biology, Interactive Systems  

---

## 📝 License

This project is open source under the **MIT License**.  
Feel free to explore, modify, and evolve it into your own digital life forms.

---

✨ Built with ❤️ by Emilie (Em’)
