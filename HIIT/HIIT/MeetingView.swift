//
//  ContentView.swift
//  HIIT
//
//  Created by Paul Kang on 2/18/25.
//

import SwiftUI
import Combine

class StopwatchViewModel: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    private var timer: AnyCancellable?
    private var isRunning = false
    private var lastStartDate: Date?
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        lastStartDate = Date()
        
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                guard let self = self, let startDate = self.lastStartDate else {return}
                self.elapsedTime += now.timeIntervalSince(startDate)
                self.lastStartDate = now
            }
    }
    
    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }
    
    func reset() {
        stop()
        elapsedTime = 0
    }
    
    func formattedTime() -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let tenths = Int((elapsedTime * 10).truncatingRemainder(dividingBy: 10))
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }
}

struct MeetingView: View {
    @StateObject private var viewModel = StopwatchViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.formattedTime())
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .padding()
            
            HStack(spacing: 20) {
                Button("Start") {
                    viewModel.start()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Stop") {
                    viewModel.stop()
                }
                .buttonStyle(.bordered)
                
                Button("Reset") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView()
    }
}

