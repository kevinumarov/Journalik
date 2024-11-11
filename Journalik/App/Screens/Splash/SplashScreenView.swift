//
//  SplashScreen.swift
//  Journalik
//
//  Created by Kevin Umarov on 9/4/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var loadingText = "Loading"
    @State private var dotCount = 0

    var body: some View {
        ZStack {
           
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()

              
                Text("Journalik")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                // Animated loading text
                Text(loadingText)
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .onAppear {
                        startLoadingAnimation()
                    }

                Spacer()
            }
        }
    }

// animation
    func startLoadingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if dotCount < 3 {
                dotCount += 1
            } else {
                dotCount = 0
            }
            loadingText = "Loading" + String(repeating: ".", count: dotCount)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
