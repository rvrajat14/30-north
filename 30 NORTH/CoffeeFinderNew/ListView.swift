//
//  ListView.swift
//  30 NORTH
//
//  Created by Anil Kumar on 11/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation
import SwiftUI


struct ListView: View {

    @ObservedObject var configuration: SunburstConfiguration

    var body: some View {
		UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

		return List {
			Section() {
				HStack {
					Spacer()
					Text(self.configuration.selectedNode == nil ? "" : "Selected: \(self.configuration.selectedNode!.name)")
					.foregroundColor(.white)
					.font(.custom(AppFontName.bold, size: 18))
					Spacer()
				}
			}
			Section() {
				HStack{
					Spacer()
					Text("Reset")
						.frame(width: 140, height: 30, alignment: .center)
						.foregroundColor(.white)
						.background(Color.init(UIColor.gold))
						.font(.custom(AppFontName.bold, size: 18))
						.overlay(
							RoundedRectangle(cornerRadius: 3)
								.stroke(Color.init(UIColor.gold), lineWidth: 1)
						)
						.onTapGesture {
							NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedResetButton"), object: nil, userInfo: nil)
						}
					Spacer()
					Text("Show Matches")
						.frame(width: 140, height: 30, alignment: .center)
						.foregroundColor(.white)
						.background(Color.init(UIColor.gold))
						.font(.custom(AppFontName.bold, size: 18))
						.overlay(
						   RoundedRectangle(cornerRadius: 3)
							.stroke(Color.init(UIColor.gold), lineWidth: 1)
						)
						.onTapGesture {
								NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedShowMatchesButton"), object: nil, userInfo: nil)
						}
					Spacer()
				}
			}
			Section() {
				HStack {
					Spacer()
					Text(self.configuration.selectedNode == nil ? "" : "   Next   ")
						.frame(width: 150, height: 30, alignment: .center)
						.foregroundColor(self.configuration.selectedNode == nil ? .clear : .white)
						.background(self.configuration.selectedNode == nil  ? Color.clear : Color.init(UIColor.gold))
						.font(.custom(AppFontName.bold, size: 18))
						.overlay(
						   RoundedRectangle(cornerRadius: 3)
							.stroke(Color.init(UIColor.gold), lineWidth: self.configuration.selectedNode == nil ? 0 : 1)
						)
						.onTapGesture {
								NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedQuestionButton"), object: nil, userInfo: nil)
						}
					Spacer()
				}
			}
		}
	}
}
