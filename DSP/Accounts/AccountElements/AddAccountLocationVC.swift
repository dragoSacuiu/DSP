//
//  AddAccountLocationVC.swift
//  DSP
//
//  Created by Sacuiu Dragos on 07/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Cocoa
import MapKit
import CoreLocation

protocol AddAccountLocationVCDelegate {
    func addLocation(longitude: Double, latitude: Double)
}

class AddAccountLocationVC: NSViewController, CLLocationManagerDelegate, NSSearchFieldDelegate, MKMapViewDelegate {
    private let dspAlert = DspAlert()
    var delegate: AddAccountLocationVCDelegate?
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    private var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        
    }

    @IBAction func searchField(_ sender: NSSearchField) {
        sender.delegate = self
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = sender.stringValue
        let search = MKLocalSearch(request: searchRequest)
        search.start{ (response,error) in
            if response == nil {
                self.dspAlert.showAlert(message: "Can't find searched location!")
            } else {
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)

                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                self.annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                self.mapView.addAnnotation(self.annotation)
                let coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.0050, longitudeDelta: 0.0050)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.region = region
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mapView.removeAnnotations(mapView.annotations)
        annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        self.mapView.addAnnotation(annotation)
    }
    @IBAction func addCoordinatesButton(_ sender: NSButton) {
        delegate?.addLocation(longitude: annotation.coordinate.longitude, latitude: annotation.coordinate.latitude)
    }
}

