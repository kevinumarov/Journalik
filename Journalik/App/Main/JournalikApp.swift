//
//  JournalikApp.swift
//  Journalik
//
//  Created by Kevin Umarov on 8/30/24.
//

import SwiftUI
import AVFoundation

@main
struct JournalikApp: App {
    @State private var isSplashScreenActive = true
    
    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreen()
                    .onAppear {
                        setupAudioSession()  // Set up audio session
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isSplashScreenActive = false
                            }
                        }
                    }
            } else {
                HomeView()
            }
        }
    }
    
    // Setup AVAudioSession with valid format
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            // Set audio session category and options
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            
            // Set preferred sample rate and buffer duration
            try audioSession.setPreferredSampleRate(44100)  // 44.1 kHz is common
            try audioSession.setPreferredIOBufferDuration(0.01)
            
            // Activate the audio session
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            print("Audio session successfully configured")
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
}
