//
//  PinAnnotation.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import MapKit

class PinAnnotation: MKPointAnnotation {
    
    enum AnnotationType {
        case PlaceAnnotation
        case RidesharingAnnotation
    }
    
    enum PlaceType: String {
        case Departure = "departure"
        case Arrival = "arrival"
        case Other
    }
    
    var annotationType: AnnotationType?
    var placeType: PlaceType?
    var identifier = "annotationViewIdentifier"
    
    init(coordinate: CLLocationCoordinate2D, annotationType: AnnotationType = .PlaceAnnotation, placeType: PlaceType = .Other) {
        super.init()
        self.coordinate = coordinate
        self.annotationType = annotationType
        self.placeType = placeType
        self.identifier = "\(annotationType.hashValue + placeType.hashValue)"
    }
    
    func getAnnotationView(annotationIdentifier: String, bundle: Bundle) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: self, reuseIdentifier: annotationIdentifier)
        annotationView.canShowCallout = false
        
        if placeType == .Departure || placeType == .Arrival {
            let annotationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
            annotationLabel.backgroundColor = Configuration.Color.main
            annotationLabel.layer.masksToBounds = true
            annotationLabel.layer.cornerRadius = 4.0
            annotationLabel.textColor = .white
            annotationLabel.text = placeType?.rawValue.localized(bundle: NavitiaSDKUI.shared.bundle)
            annotationLabel.font = UIFont(descriptor: annotationLabel.font.fontDescriptor, size: 14)
            annotationLabel.textAlignment = NSTextAlignment.center
            annotationLabel.alpha = 1
            
            if annotationType == .RidesharingAnnotation {
                let annotationImage = UIImageView(frame: CGRect(x: 30, y: 27, width: 20, height: 30))
                annotationImage.image = UIImage(named: "ridesharing_pin", in: bundle, compatibleWith: nil)
                
                annotationView.addSubview(annotationImage)
            } else {
                let annotationPin = UILabel(frame: CGRect(x: 28, y: 27, width: 26, height: 26))
                annotationPin.attributedText = NSMutableAttributedString()
                    .icon("location-pin",
                          color: self.placeType == .Departure ? Configuration.Color.origin : Configuration.Color.destination,
                          size: 26)
                
                annotationView.addSubview(annotationPin)
            }
            
            annotationView.addSubview(annotationLabel)
            annotationView.frame = CGRect(x: 0, y: 0, width: 80, height: 100)
        } else {
            if annotationType == .RidesharingAnnotation {
                let annotationImage = UIImageView(frame: CGRect(x: 0, y: -15, width: 20, height: 30))
                annotationImage.image = UIImage(named: "ridesharing_pin", in: bundle, compatibleWith: nil)
                
                annotationView.addSubview(annotationImage)
                annotationView.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
            }
        }
        
        return annotationView
    }
    
}
