//
//  ViewController.swift
//  Test
//
//  Created by Gnani on 27/8/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class EnterLocationsVC: UIViewController {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 16.0
    var mapView: GMSMapView!
    
    @IBOutlet weak var pickupButton: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var pickupPlace: GMSPlace?
    var destinationPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        
        self.setupLocationServices()
        
        placesClient = GMSPlacesClient.shared()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setupMapView()
    }
    
    private func setupViews() {
        
        pickupButton.layer.borderColor = UIColor.black.cgColor
        pickupButton.layer.borderWidth = 1.0
        pickupButton.layer.shadowColor = UIColor.gray.cgColor
        pickupButton.layer.shadowOpacity = 1
        pickupButton.layer.shadowOffset = CGSize.zero
        pickupButton.layer.shadowRadius = 5
        pickupButton.tag = 123
        
        destinationButton.layer.borderColor = UIColor.black.cgColor
        destinationButton.layer.borderWidth = 1.0
        destinationButton.layer.shadowColor = UIColor.gray.cgColor
        destinationButton.layer.shadowOpacity = 1
        destinationButton.layer.shadowOffset = CGSize.zero
        destinationButton.layer.shadowRadius = 5
        destinationButton.tag = 321
        
        doneButton.layer.shadowColor = UIColor.black.cgColor
        doneButton.layer.shadowOpacity = 0.5
        doneButton.layer.shadowOffset = CGSize.zero
        doneButton.layer.shadowRadius = 5
        doneButton.isEnabled = false
    }
    
    private func setupLocationServices() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    private func setupMapView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 17.4133954, longitude: 78.461314, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        mapView.preferredFrameRate = .conservative
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "map_style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        
        // Add the map to the view, hide it until we've got a location update.
    }
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        self.view.tag = sender.tag
        let autocompleteController = GMSAutocompleteViewController()
        
        let autocompleteFilter = GMSAutocompleteFilter()
        if let regionCode = Locale.current.regionCode {
            autocompleteFilter.country = regionCode
        }
        autocompleteController.autocompleteFilter = autocompleteFilter
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        
        let vc = SelectRideVC(withMapView: self.mapView, pickupPlace: pickupPlace, andDestinationPlace: destinationPlace)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension EnterLocationsVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension EnterLocationsVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if self.view.tag == 123 {
            pickupButton.setTitle(place.name, for: .normal)
            pickupButton.backgroundColor = UIColor.lightText
            pickupButton.setTitleColor(UIColor.darkGray, for: .normal)
            
            pickupPlace = place
            
        } else if self.view.tag == 321 {
            destinationButton.setTitle(place.name, for: .normal)
            destinationButton.backgroundColor = UIColor.lightText
            destinationButton.setTitleColor(UIColor.darkGray, for: .normal)
            
            destinationPlace = place
        }
        
        if let _ = pickupPlace, let _ = destinationPlace {
            self.doneButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

