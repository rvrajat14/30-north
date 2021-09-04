//
//  SettingView.swift
//  30 NORTH
//
//  Created by Anil Kumar on 07/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import SwiftUI

final class SettingsView: UIViewRepresentable {

    @ObservedObject var configuration: SunburstConfiguration

	init(configuration:SunburstConfiguration) {
		self.configuration = configuration
	}

	func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    struct ContentView : View {
        var body: some View {
           Button(action: {
                print("Button action")
            }) {
                Text("Button label")
                    .padding(10.0)
                    .overlay(
						RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .shadow(color: .blue, radius: 10.0)
                    )
            }
        }
    }

    // 3.
    func updateUIView(_ uiView: UIView, context: Context) {
		if let node = configuration.selectedNode {
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangeNode"), object: nil, userInfo: ["SelectedNode": node, "FocusedNode": configuration.focusedNode ?? nil])
		}
    }

    /*@State private var parentTotalValue: Double? = nil
    @State private var arcAngleShownIfLessThan: Double = 0.0

    var body: some View {
        NavigationView {
            Form {
                Section(header:Text("Interactions").font(.system(size: 10.0))) {
                    HStack {
                        Text("selectedNode")
                        Spacer()
                        Text(configuration.selectedNode == nil ? "none" : configuration.selectedNode!.name).foregroundColor(Color.secondary)
						//if let node = configuration.selectedNode {
							//NotificationCenter.default.post(name: NSNotification.Name("didSelectNode"), object: node)
						//}
                    }
                    HStack {
                        Text("focusedNode")
                        Spacer()
                        Text(configuration.focusedNode == nil ? "none" : configuration.focusedNode!.name).foregroundColor(Color.secondary)
                    }
                }
            }.navigationBarTitle(Text("Configuration"))
        }
    }*/
}

extension SunburstConfiguration {

    static let defaultMaximumExpandedRingsShownCount: UInt = 2
    static let defaultMaximumRingsShownCount: UInt = 2

    // MARK: maximumExpandedRingsShownCount bindings

    var maximumExpandedRingsShownCountSliderBinding: Binding<Double> {
        return Binding(get: { () -> Double in
            return Double(self.maximumExpandedRingsShownCount ?? SunburstConfiguration.defaultMaximumExpandedRingsShownCount)
        }, set: { (value) in
            self.maximumExpandedRingsShownCount = UInt(value)
        })
    }

    var maximumExpandedRingsShownCountToggleBinding: Binding<Bool> {
        return Binding(get: { () -> Bool in
            return self.maximumExpandedRingsShownCount != nil
        }, set: { (value) in
            self.maximumExpandedRingsShownCount = value ? SunburstConfiguration.defaultMaximumExpandedRingsShownCount : nil
        })
    }

    // MARK: maximumRingsShownCount bindings

    var maximumRingsShownCountSliderBinding: Binding<Double> {
        return Binding(get: { () -> Double in
            return Double(self.maximumRingsShownCount ?? SunburstConfiguration.defaultMaximumRingsShownCount)
        }, set: { (value) in
            self.maximumRingsShownCount = UInt(value)
        })
    }

    var maximumRingsShownCountToggleBinding: Binding<Bool> {
        return Binding(get: { () -> Bool in
            return self.maximumRingsShownCount != nil
        }, set: { (value) in
            self.maximumRingsShownCount = value ? SunburstConfiguration.defaultMaximumRingsShownCount : nil
        })
    }
}
