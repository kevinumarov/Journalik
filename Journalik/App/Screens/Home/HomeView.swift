//
//  HomeView.swift
//  Journalik
//
//  Created by Kevin Umarov on 9/3/24.
//

import SwiftUI
import Foundation

struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    var content: String
}

struct HomeView: View {
    
    @State private var showBottomSheet = false
    @State private var journalEntries: [JournalEntry] = [] // Store journal entries
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    // Header Section
                    HStack {
                        Text("Journalik")
                            .font(Theme.Font.titleFont)
                            .foregroundColor(Theme.Colors.primaryTextColor)
                        
                        Spacer()
                        
                        Theme.Images.gearIcon
                            .resizable()
                            .frame(width: 24, height: 24) // Customize size if needed
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Today")
                                .font(Theme.Font.largeTitleFont)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        Text("Today is one of the beautiful days of your life.")
                            .font(Theme.Font.bodyFont)
                            .foregroundColor(Theme.Colors.accentColor)
                            .frame(width: 128, alignment: .leading)
                            .padding(.bottom, 20)
                        
                        Button(action: {
                            // Show the bottom sheet when pressed
                            withAnimation {
                                showBottomSheet.toggle()
                            }
                        }) {
                            Text("Name today")
                                .font(Theme.Font.buttonFont) // You can reduce the font size in Theme.Font.buttonFont if needed
                                  .foregroundColor(Theme.Colors.accentColor)
                                  .padding(.horizontal, 10)  // Smaller horizontal padding
                                  .padding(.vertical, 5)     // Smaller vertical padding
                                  .frame(maxWidth: 150)      // Limit the button width to 150, you can adjust this value
                                  .background(Theme.Colors.accentColor.opacity(0.1))
                                  .cornerRadius(10)                        }
                    }
                    
                    
                    .padding()
                    .background(Color.black) // Set black color as background
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .foregroundColor(Theme.Colors.accentColor)

                    
                    
                    
                    // Journal Entries Section
                    VStack(alignment: .leading) {
                        HStack {
                            Text("My journaliks")
                                .font(Theme.Font.headlineFont)
                            Spacer()
                            Text("VIEW MORE")
                                .font(Theme.Font.bodyFont)
                                .foregroundColor(Theme.Colors.secondaryTextColor)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        // Journal List
                        ScrollView {
                                                  VStack(spacing: 10) {
                                                      ForEach(journalEntries) { entry in
                                                          JournalEntryView(date: entry.date, content: entry.content)
                                                      }
                                                  }
                                                  .padding(.horizontal)
                                              }
                                          }
                                          .padding(.top, 10)
                    
                    Spacer()
                    
                    // Floating "Plus" Button
                    VStack {
                        Spacer()
                        NavigationLink {
                            TodayScreenView(journalEntries: $journalEntries)
                        } label: {
                            Theme.Images.plusIcon
                                .resizable()
                                .frame(width: 32, height: 32) // Customize size if needed
                                .foregroundColor(.white)
                                .padding()
                                .background(Theme.Colors.backgroundColor)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.bottom, 40)
                    }
                }
                
                // Custom Bottom Sheet
                if showBottomSheet {
                    BottomSheetView(showBottomSheet: $showBottomSheet)
                        .transition(.move(edge: .bottom))
                        .animation(.spring())
                }
                
            }
        }
        
    }
    
    // Bottom Sheet View
    struct BottomSheetView: View {
        @Binding var showBottomSheet: Bool
        @State private var dayName: String = "Romantic"
        
        var body: some View {
            VStack {
                Spacer()
                
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showBottomSheet = false
                            }
                        }) {
                            Theme.Images.closeIcon
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    
                    Text("Name Your Day")
                        .font(Theme.Font.largeTitleFont)
                        .foregroundColor(Theme.Colors.accentColor)
                        .padding()
                    
                    HStack {
                        Theme.Images.heartIcon
                            .font(.title)
                            .foregroundColor(.white)
                        
                        TextField("Enter a name", text: $dayName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Button(action: {
                        // Action to save the day name
                    }) {
                        Text("Save")
                            .font(Theme.Font.buttonFont)
                            .foregroundColor(Theme.Colors.accentColor)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.Colors.backgroundColor)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .frame(height: 300)
                .background(Theme.Colors.backgroundColor.opacity(0.9))
                .cornerRadius(20)
                .shadow(radius: 20)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    
    struct JournalEntryView: View {
        var date: Date
        var content: String
        
        var body: some View {
            HStack {
                Image(systemName: "book")
                    .font(.title)
                VStack(alignment: .leading) {
                    Text(formatDate(date)) // Convert Date to String
                        .font(Theme.Font.headlineFont)
                    Text(content)
                        .font(Theme.Font.bodyFont)
                        .lineLimit(2) // Limit to 2 lines
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        
        // Helper function to format the Date to String
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    }

    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
}
