import SwiftUI

struct ArcKnob: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var title: String
    var unit: String = ""
    
    @State private var previousValue: Double = 0
    @State private var dragOffset: CGFloat = 0
    
    // Aesthetic Parameters
    var size: CGFloat = 60
    var trackWidth: CGFloat = 4
    
    var normalizedValue: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background Track
                Circle()
                    .trim(from: 0.15, to: 0.85)
                    .stroke(Color.black.opacity(0.4), style: StrokeStyle(lineWidth: trackWidth, lineCap: .round))
                    .rotationEffect(.degrees(90))
                    .frame(width: size, height: size)
                
                // Active Track
                Circle()
                    .trim(from: 0.15, to: 0.15 + (0.7 * normalizedValue))
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.cyan.opacity(0.7), Color.cyan]), startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: trackWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(90))
                    .frame(width: size, height: size)
                    .shadow(color: Color.cyan.opacity(0.6), radius: 4, x: 0, y: 0)
                
                // Indicator / Value
                Text(String(format: "%.1f", value) + unit)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }
            // Gesture Area (Invisible)
            .contentShape(Circle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let delta = -gesture.translation.height / 150.0 // Sensitivity
                        let newValue = min(max(previousValue + delta * (range.upperBound - range.lowerBound), range.lowerBound), range.upperBound)
                        value = newValue
                    }
                    .onEnded { _ in
                        previousValue = value
                    }
            )
            .onAppear {
                previousValue = value
            }
            
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(width: size + 10)
        }
    }
}

// Styles the look of a Rack Unit
struct RackPanel<Content: View>: View {
    var title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text(title.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
                    .tracking(1.5)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.05))
            
            // Content
            content
                .padding(12)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.12))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct ModernSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text(String(format: "%.1f", value))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)), height: 4)
                        .cornerRadius(2)
                        .shadow(color: Color.cyan.opacity(0.5), radius: 2)
                }
            }
            .frame(height: 10)
    }
}
}

struct EffectGroup<Content: View>: View {
    var title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.cyan)
                .tracking(1)
            
            VStack {
                content
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

