//
//  CellularLifeView.swift
//  CellularLifeView
//
//  Created by Emilie on 19/10/2025.
//
import SwiftUI

struct CellularLifeView: View {
    @State private var cells: [Cell] = []
    @State private var generationCount: Int = 0
    @State private var totalCells: Int = 0
    @State private var activeCells: Int = 0
    @State private var showMetrics: Bool = true
    @State private var simulationSpeed: Double = 1.0
    @State private var timeElapsed: Int = 0
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BiologicalBackground(cellCount: cells.count)
                ZStack {
                    ForEach(cells) { cell in
                        CellView(cell: cell, geometry: geometry)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                VStack {
                    if showMetrics {
                        HStack(spacing: 16) {
                            BiologicalStatusCard(
                                icon: "circle.grid.cross.fill",
                                title: "Active Cells",
                                value: "\(activeCells)",
                                color: .green,
                                isActive: true
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                            
                            BiologicalStatusCard(
                                icon: "arrow.triangle.branch",
                                title: "Generation",
                                value: "\(generationCount)",
                                color: .cyan,
                                isActive: false
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 60)
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showMetrics.toggle()
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: showMetrics ? "eye.slash.fill" : "chart.bar.fill")
                                    .font(.system(size: 12, weight: .semibold))
                                Text(showMetrics ? "Hide Metrics" : "Show Metrics")
                                    .font(.system(size: 11, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.green.opacity(0.4), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 24)
                    }
                    .padding(.bottom, 12)
                    
                    if showMetrics {
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                CellMetricCard(
                                    icon: "chart.line.uptrend.xyaxis",
                                    label: "Total Births",
                                    value: "\(totalCells)",
                                    color: .blue
                                )
                                
                                CellMetricCard(
                                    icon: "timer",
                                    label: "Simulation Time",
                                    value: formatTime(timeElapsed),
                                    color: .purple
                                )
                                
                                CellMetricCard(
                                    icon: "speedometer",
                                    label: "Speed",
                                    value: String(format: "%.1fx", simulationSpeed),
                                    color: .mint
                                )
                            }
                            
                            Text("Cellular Life Simulation • Computational Biology")
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                                .textCase(.uppercase)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            updateSimulation()
        }
        .onAppear {
            initializeSimulation()
            startMetricsTracking()
        }
    }
    
    func initializeSimulation() {
        for _ in 0..<5 {
            createCell(at: nil, generation: 0)
        }
    }
    
    func createCell(at position: CGPoint?, generation: Int) {
        let newCell = Cell(
            position: position ?? CGPoint(
                x: CGFloat.random(in: 0.2...0.8),
                y: CGFloat.random(in: 0.2...0.8)
            ),
            velocity: CGPoint(
                x: CGFloat.random(in: -0.001...0.001),
                y: CGFloat.random(in: -0.001...0.001)
            ),
            size: CGFloat.random(in: 40...80),
            color: randomCellColor(),
            generation: generation,
            energy: CGFloat.random(in: 0.7...1.0)
        )
        
        cells.append(newCell)
        totalCells += 1
    }
    
    func randomCellColor() -> Color {
        let colors: [Color] = [
            .green, .mint, .cyan, .blue, .purple, .pink, .teal
        ]
        return colors.randomElement() ?? .green
    }
    
    func updateSimulation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            for i in cells.indices {
                cells[i].position.x += cells[i].velocity.x * simulationSpeed
                cells[i].position.y += cells[i].velocity.y * simulationSpeed
                if cells[i].position.x < 0.05 || cells[i].position.x > 0.95 {
                    cells[i].velocity.x *= -1
                }
                if cells[i].position.y < 0.05 || cells[i].position.y > 0.95 {
                    cells[i].velocity.y *= -1
                }
                cells[i].age += 1
                cells[i].energy -= 0.0003 * simulationSpeed
                cells[i].pulsePhase += 0.05
                if cells[i].age > 500 || cells[i].energy <= 0 {
                    cells[i].isDying = true
                    cells[i].opacity -= 0.02
                }
            }
            handleCellDivision()
            handleCellMerging()
            cells.removeAll { $0.isDying && $0.opacity <= 0 }
            activeCells = cells.filter { !$0.isDying }.count
            if cells.count < 3 {
                createCell(at: nil, generation: generationCount)
            }
        }
    }
    
    func handleCellDivision() {
        var newCells: [Cell] = []
        
        for i in cells.indices {
            let shouldDivide = cells[i].energy > 0.8 &&
                               cells[i].age > 100 &&
                               cells[i].age < 300 &&
                               !cells[i].isDying &&
                               cells.count < 30 &&
                               Double.random(in: 0...1) < 0.01
            
            if shouldDivide {
                let offset = CGFloat.random(in: 0.05...0.1)
                let angle = CGFloat.random(in: 0...(2 * .pi))
                
                let childPosition = CGPoint(
                    x: cells[i].position.x + cos(angle) * offset,
                    y: cells[i].position.y + sin(angle) * offset
                )
                
                var childCell = Cell(
                    position: childPosition,
                    velocity: CGPoint(
                        x: cos(angle) * 0.002,
                        y: sin(angle) * 0.002
                    ),
                    size: cells[i].size * 0.7,
                    color: mutateCellColor(cells[i].color),
                    generation: cells[i].generation + 1,
                    energy: 0.6
                )
                childCell.scale = 0.1
                
                newCells.append(childCell)
                cells[i].energy -= 0.3
                
                generationCount = max(generationCount, childCell.generation)
            }
        }
        
        cells.append(contentsOf: newCells)
        totalCells += newCells.count
    }
    
    func handleCellMerging() {
        var indicesToRemove: Set<Int> = []
        
        for i in cells.indices {
            if indicesToRemove.contains(i) { continue }
            
            for j in (i+1)..<cells.count {
                if indicesToRemove.contains(j) { continue }
                
                let distance = hypot(
                    cells[i].position.x - cells[j].position.x,
                    cells[i].position.y - cells[j].position.y
                )
                if distance < 0.08 && Double.random(in: 0...1) < 0.005 {
                    let mergedPosition = CGPoint(
                        x: (cells[i].position.x + cells[j].position.x) / 2,
                        y: (cells[i].position.y + cells[j].position.y) / 2
                    )
                    
                    var mergedCell = Cell(
                        position: mergedPosition,
                        velocity: CGPoint(
                            x: (cells[i].velocity.x + cells[j].velocity.x) / 2,
                            y: (cells[i].velocity.y + cells[j].velocity.y) / 2
                        ),
                        size: (cells[i].size + cells[j].size) * 0.7,
                        color: blendColors(cells[i].color, cells[j].color),
                        generation: max(cells[i].generation, cells[j].generation),
                        energy: (cells[i].energy + cells[j].energy) / 2 + 0.2
                    )
                    mergedCell.scale = 0.5
                    
                    cells.append(mergedCell)
                    indicesToRemove.insert(i)
                    indicesToRemove.insert(j)
                    
                    totalCells += 1
                    break
                }
            }
        }
        for index in indicesToRemove.sorted().reversed() {
            cells[index].isDying = true
            cells[index].opacity = 0
        }
    }
    
    func mutateCellColor(_ color: Color) -> Color {
        let colors: [Color] = [.green, .mint, .cyan, .blue, .purple, .pink, .teal]
        if Double.random(in: 0...1) < 0.7 {
            return color
        } else {
            return colors.randomElement() ?? color
        }
    }
    
    func blendColors(_ color1: Color, _ color2: Color) -> Color {
        let colors: [Color] = [.green, .mint, .cyan, .blue, .purple, .pink, .teal]
        return colors.randomElement() ?? .cyan
    }
    
    func startMetricsTracking() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeElapsed += 1
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
struct Cell: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var color: Color
    var generation: Int
    var energy: CGFloat
    var age: Int = 0
    var isDying: Bool = false
    var opacity: CGFloat = 1.0
    var scale: CGFloat = 1.0
    var pulsePhase: CGFloat = 0
}
struct CellView: View {
    let cell: Cell
    let geometry: GeometryProxy
    
    var body: some View {
        let x = cell.position.x * geometry.size.width
        let y = cell.position.y * geometry.size.height
        let pulse = 1.0 + sin(cell.pulsePhase) * 0.1
        
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            cell.color.opacity(Double(cell.energy) * 0.3),
                            cell.color.opacity(Double(cell.energy) * 0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: cell.size * 0.8
                    )
                )
                .frame(width: cell.size * 1.6, height: cell.size * 1.6)
                .blur(radius: 20)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            cell.color.opacity(0.8),
                            cell.color.opacity(0.5),
                            cell.color.opacity(0.2)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: cell.size / 2
                    )
                )
                .frame(width: cell.size, height: cell.size)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.6),
                                    cell.color.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .white.opacity(0.9),
                            cell.color.opacity(0.9),
                            cell.color.opacity(0.6)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: cell.size * 0.2
                    )
                )
                .frame(width: cell.size * 0.4, height: cell.size * 0.4)
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .white.opacity(0.8),
                                cell.color.opacity(0.6)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 3
                        )
                    )
                    .frame(width: 6, height: 6)
                    .offset(
                        x: cos(cell.pulsePhase + CGFloat(i) * 2) * cell.size * 0.25,
                        y: sin(cell.pulsePhase + CGFloat(i) * 2) * cell.size * 0.25
                    )
            }
            if cell.energy < 0.4 {
                Circle()
                    .stroke(Color.red.opacity(0.6), lineWidth: 3)
                    .frame(width: cell.size * 1.1, height: cell.size * 1.1)
            }
        }
        .scaleEffect(cell.scale * pulse)
        .opacity(Double(cell.opacity))
        .position(x: x, y: y)
        .shadow(color: cell.color.opacity(Double(cell.energy) * 0.6), radius: 15, x: 0, y: 0)
    }
}
struct BiologicalBackground: View {
    let cellCount: Int
    @State private var particleOffset: CGFloat = 0
    @State private var wavePhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.01, green: 0.03, blue: 0.02),
                    Color(red: 0.02, green: 0.05, blue: 0.04),
                    Color(red: 0.03, green: 0.07, blue: 0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Canvas { context, size in
               
                for i in 0..<50 {
                    let x = (CGFloat(i) * size.width / 50 + particleOffset * 0.2).truncatingRemainder(dividingBy: size.width)
                    let y = (CGFloat(i * 23) + particleOffset + sin(CGFloat(i) * 0.4 + wavePhase) * 40).truncatingRemainder(dividingBy: size.height)
                    let particleSize = 2.0 + sin(wavePhase + CGFloat(i)) * 1.5
                    let opacity = 0.15 + sin(wavePhase + CGFloat(i) * 0.3) * 0.1
                    
                    context.fill(
                        Circle().path(in: CGRect(x: x, y: y, width: particleSize, height: particleSize)),
                        with: .color(.green.opacity(Double(opacity)))
                    )
                }
                var path = Path()
                path.move(to: CGPoint(x: 0, y: size.height * 0.3))
                
                for x in stride(from: 0, through: size.width, by: 10) {
                    let y = size.height * 0.3 + sin(x * 0.02 + wavePhase) * 40 + cos(x * 0.01 + wavePhase * 0.5) * 20
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                context.stroke(path, with: .color(.mint.opacity(0.1)), lineWidth: 2)
                var path2 = Path()
                path2.move(to: CGPoint(x: 0, y: size.height * 0.7))
                
                for x in stride(from: 0, through: size.width, by: 10) {
                    let y = size.height * 0.7 + sin(x * 0.015 - wavePhase) * 50 + cos(x * 0.008 - wavePhase * 0.7) * 25
                    path2.addLine(to: CGPoint(x: x, y: y))
                }
                
                context.stroke(path2, with: .color(.cyan.opacity(0.08)), lineWidth: 2)
            }
            RadialGradient(
                colors: [
                    Color.green.opacity(Double(min(cellCount, 30)) / 30.0 * 0.1),
                    Color.clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 500
            )
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
                particleOffset = UIScreen.main.bounds.height
            }
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                wavePhase = .pi * 4
            }
        }
    }
}

struct BiologicalStatusCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
                .symbolEffect(.pulse, isActive: isActive)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(color)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [color.opacity(0.5), color.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: color.opacity(0.4), radius: 12, x: 0, y: 6)
    }
}

struct CellMetricCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    CellularLifeView()
}
