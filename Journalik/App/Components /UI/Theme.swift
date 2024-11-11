//
//  Theme.swift
//  Journalik
//
//  Created by Kevin Umarov on 9/12/24.
//

import Foundation
import SwiftUI


struct Theme {
    // MARK: - Fonts
    struct Font {
        static let titleFont = SwiftUI.Font.custom("Halvetica", size: 24)
        static let headlineFont = SwiftUI.Font.custom("Halvetica", size: 16).weight(.semibold)
        static let bodyFont = SwiftUI.Font.custom("SF Pro", size: 12).weight(.semibold)
        static let buttonFont = SwiftUI.Font.custom("SF Pro", size: 18)
        static let largeTitleFont = SwiftUI.Font.custom("Halvetica", size: 32)
    }
    
    // MARK: - Colors
    struct Colors {
        static let primaryTextColor = Color.black
        static let secondaryTextColor = Color.gray
        static let accentColor = Color.white
        static let backgroundColor = Color.black
    }
    
    // MARK: - Images
    struct Images {
        static let bannerBackground = Image("background")
        static let gearIcon = Image("settings") // Replace with your custom image
        static let heartIcon = Image(systemName: "heartWhite") // You can replace system images with custom ones
        static let heartFillIcon = Image(systemName: "heartBlack") // Replace if needed
        static let bookIcon = Image("notebook") // changed
        static let closeIcon = Image(systemName: "xmark.circle.fill")
        static let plusIcon = Image("addWhite")
    }
}

