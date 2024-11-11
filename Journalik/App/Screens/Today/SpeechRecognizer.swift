//
//  SpeechRecognizer.swift
//  Journalik
//
//  Created by Kevin Umarov on 9/24/24.
//

import Foundation
import Speech
import Combine
import AVFoundation
import AVFAudio

class SpeechRecognizer: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var recognizedText = "" // Holds the transcribed text during speech
    @Published var isListening = false // Track if it's currently listening

    // Function to start listening to the user's voice
    func startListening() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else { return }
        
        let inputNode = audioEngine.inputNode
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                // Display transcribed text in real-time (R4)
                DispatchQueue.main.async {
                    self.recognizedText = self.formatTextWithPunctuation(result.bestTranscription.formattedString)
                }
            }
            
            if error != nil || result?.isFinal == true {
                // Stop audio if there's an error or the result is final
                self.stopListening()
            }
        }
        
        // Start the audio session
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            DispatchQueue.main.async {
                self.isListening = true
            }
        } catch {
            print("Audio Engine couldn't start: \(error.localizedDescription)")
        }
    }

    // Function to stop listening
    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        DispatchQueue.main.async {
            self.isListening = false
        }
    }
    
    // Request speech recognition authorization
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied, .restricted, .notDetermined:
                print("Speech recognition authorization failed")
            @unknown default:
                print("Unknown speech recognition authorization status")
            }
        }
    }
    
    // Function to format text with basic punctuation rules
    private func formatTextWithPunctuation(_ text: String) -> String {
        var formattedText = text

        // Separate the text into words
        let words = formattedText.split(separator: " ")

        // Rebuild the text with punctuation
        var result = ""
        var sentenceStart = true
        
        for word in words {
            // Capitalize the first word of a new sentence
            if sentenceStart {
                result += word.prefix(1).capitalized + word.dropFirst()
                sentenceStart = false
            } else {
                result += " " + word
            }

            // Insert a period if the word is likely the end of a sentence (simple heuristic)
            if word.hasSuffix(".") || word.hasSuffix("?") || word.hasSuffix("!") {
                sentenceStart = true
            }
        }

        // If the final word doesn't have punctuation, add a period
        if !result.hasSuffix(".") && !result.hasSuffix("?") && !result.hasSuffix("!") {
            result += "."
        }

        return result
    }

    // Clean up resources when object is deallocated
    deinit {
        stopListening()
    }
}
