//
//  RootView.swift
//  30 NORTH
//
//  Created by Anil Kumar on 07/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation
import SwiftUI


struct RootView: View {

    @ObservedObject var configuration: SunburstConfiguration

    var body: some View {
        AnyView(GeometryReader { geometry -> AnyView in
            if geometry.size.width <= geometry.size.height {
                return AnyView (
                    VStack(spacing: 10) {
						Text("COFFEE FINDER")
							.foregroundColor(Color.init(UIColor.gold))
							.font(.custom(AppFontName.bold, size: 23))

                        SunburstView(configuration: self.configuration)
                        //Divider().edgesIgnoringSafeArea(.all)
						ListView(configuration: self.configuration).frame(width: geometry.size.width, height: 200)
						SettingsView(configuration: self.configuration).fixedSize().frame(width: geometry.size.width, height: 50)
                    }
                )
            } else {
                return AnyView(
                    HStack(spacing: 0) {
                        SunburstView(configuration: self.configuration)
                        Divider()
						ListView(configuration: self.configuration)
						SettingsView(configuration: self.configuration)
                    }
                )
            }
        })
    }
}
