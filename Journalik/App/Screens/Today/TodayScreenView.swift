//
//  TodayScreenView.swift
//  Journalik
//
//  Created by Kevin Umarov on 9/4/24.
//

import SwiftUI
import Speech
import Combine
import AVFoundation



struct TodayScreenView: View {
    @Binding var journalEntries: [JournalEntry] // Reference to the journal entries list
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var savedText = ""
    @State private var isMicDisabled = false

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // Optional background color
            
            VStack {
                // Header with back button, title, and action buttons
                HStack {
                    Button(action: {
                        saveAndExit() // Save text and go back to HomeView (R7)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.black)
                            .accessibilityLabel("Go back")
                    }
                    
                    Spacer()
                    
                    Text("Fantastic Day")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .background(Color.white)
                
                Spacer()
                
                // Date section displaying current date
                Text(currentDate())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // Text content
                ScrollView {
                    Text(savedText + (speechRecognizer.isListening ? "\n\n\(speechRecognizer.recognizedText)" : ""))
                        .padding()
                }
                
                Spacer()
                
                // Floating Button for recording speech
                Button(action: {
                    if speechRecognizer.isListening {
                        speechRecognizer.stopListening()
                        savedText += speechRecognizer.recognizedText
                        speechRecognizer.recognizedText = ""
                    } else {
                        speechRecognizer.startListening()
                    }
                }) {
                    Image(systemName: speechRecognizer.isListening ? "mic.circle.fill" : "mic.circle")
                        .font(.largeTitle)
                        .foregroundColor(isMicDisabled ? .gray : .white)
                        .padding()
                        .background(isMicDisabled ? Color.gray : Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .accessibilityLabel("Record")
                }
                .disabled(isMicDisabled) // R6: Disable mic button after 11:59 PM
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            checkForEndOfDay()
            speechRecognizer.requestAuthorization()
        }
        .onDisappear {
            speechRecognizer.stopListening()
        }
    }

    // Helper to save the journal entry and exit
    private func saveAndExit() {
        if !savedText.isEmpty {
            let newEntry = JournalEntry(date: Date(), content: savedText)
            journalEntries.append(newEntry) // R5: Save journal entry by date
        }
        speechRecognizer.stopListening()
        // Navigate back to HomeView (in real app, you'd use a NavigationLink or dismiss the view)
    }

    // Check if it's past 11:59:00 PM and disable editing if true
    private func checkForEndOfDay() {
        let currentTime = Date()
        let calendar = Calendar.current
        if let elevenPM = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: currentTime),
           currentTime >= elevenPM {
            isMicDisabled = true // R6: Disable mic button after 11:59 PM
        }
    }

    // Get current date
    private func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

