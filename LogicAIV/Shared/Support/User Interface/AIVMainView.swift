import SwiftUI
import CoreAudioKit
import AIVFramework

public struct AIVMainView: View {
    @StateObject public var viewModel = AudioUnitViewModel()
    public var audioUnit: AIVDemo?

    public init(audioUnit: AIVDemo? = nil) {
        self.audioUnit = audioUnit
    }
    
    public var body: some View {
        ZStack {
            // Dark Background
            Color(red: 0.08, green: 0.08, blue: 0.10).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header (Fixed)
                HStack {
                    Text("AIV VOCAL CHAIN")
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .tracking(3)
                        .shadow(color: .white.opacity(0.2), radius: 5)
                    
                    Spacer()
                    
                    Text("RACK VIEW")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(4)
                }
                .padding()
                .background(Color(red: 0.12, green: 0.12, blue: 0.14))
                .shadow(radius: 5)
                .zIndex(1) // Keep header above scroll
                
                // Scrollable Rack
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 15) {
                        OutputPanel(viewModel: viewModel)
                        InputPanel(viewModel: viewModel)
                        GatePanel(viewModel: viewModel)
                        PitchDeesserPanel(viewModel: viewModel)
                        EQPanel(viewModel: viewModel)
                        DynamicsPanel(viewModel: viewModel)
                        SpatialPanel(viewModel: viewModel)
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            if let au = audioUnit {
                viewModel.connect(audioUnit: au)
            }
        }
        .onChange(of: audioUnit) { newAU in
             if let au = newAU {
                 viewModel.connect(audioUnit: au)
             }
        }
    }
}
