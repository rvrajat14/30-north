//
//  ShopAnnotation.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 18/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import MapKit

class ShopAnnotation : NSObject, MKAnnotation {
    let index: Int?
    let id: String?
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(index: Int, id: String, title: String, locationName: String, lat: Double, lng: Double) {
        self.index = index
        self.id = id
        self.title = title
        self.locationName = locationName
        self.coordinate = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(lng))
        //self.coordinate = coordinate
    }
    

    
    var subtitle: String? {
        return locationName
        
        
    }
    
    func pinColor() -> UIColor  {
        return .red
    }
}
