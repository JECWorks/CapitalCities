//
//  Pin.swift
//  CapitalCities
//
//  Created by Jason Cox on 6/1/24.
//

import Cocoa
import MapKit

class Pin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var color: NSColor
    
    init(title: String? = nil, subtitle: String? = nil, coordinate: CLLocationCoordinate2D, color: NSColor = NSColor.green) {
        self.title = title
        // self.subtitle = subtitle
        self.coordinate = coordinate
        self.color = color
    }

}
