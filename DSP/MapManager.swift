//
//  MapManager.swift
//  DSP
//
//  Created by Sacuiu Dragos on 17/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Foundation
import MapKit

class MapManager {
    
    private let bucharestCenterCoordinate = CLLocationCoordinate2D(latitude: 44.42676678769212 ,longitude: 26.10243551496884)
    private let annotationSpan = MKCoordinateSpan(latitudeDelta: 0.0050, longitudeDelta: 0.0050)
    private let areaSpan = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
    
    func showItemOnMap(map: MKMapView, name: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        map.addAnnotation(annotation)
        setMapRegion(map: map, coordinate: annotation.coordinate, span: annotationSpan)
        map.selectAnnotation(annotation, animated: true)
    }
    
    func setDefault(map: MKMapView) {
        setMapRegion(map: map, coordinate: bucharestCenterCoordinate, span: areaSpan)
    }
    
    private func setMapRegion(map: MKMapView, coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        let region = MKCoordinateRegion(center: coordinate, span: span)
        map.region = region
    }
    
    func calculateDistance(map: MKMapView, source: CLLocation, destination: CLLocation) -> CLLocationDistance {
        return source.distance(from: destination) / 1000
    }
    
    func calculatingRout(map: MKMapView, source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let sourceLocation = MKMapItem(placemark: MKPlacemark(coordinate: source))
        let destinationLocation = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceLocation
        directionRequest.destination = destinationLocation
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [unowned map] response, error in
            guard let unwrappedResponse = response else {return}
            
            for route in unwrappedResponse.routes {
                map.addOverlay(route.polyline)
                map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
}
