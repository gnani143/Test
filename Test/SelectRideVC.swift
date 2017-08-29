//
//  SelectRideVC.swift
//  Test
//
//  Created by Gnani on 27/8/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SelectRideVC: UIViewController {
    
    var mapView: GMSMapView!
    
    var backButton = UIButton(frame: CGRect(x: 12.0, y: 16.0, width: 60.0, height: 60.0))
    var selectRideAndPaymentView: SelectRideAndPaymentView!
    
    var pickupPlace: GMSPlace?
    var destinationPlace: GMSPlace?
    
    var pickupPlaceMarker: GMSMarker?
    var destinationPlaceMarker: GMSMarker?
    
    var rideDuration: String?
    var rideDistance: String?
    
    init(withMapView mapView: GMSMapView, pickupPlace: GMSPlace?, andDestinationPlace destinationPlace: GMSPlace?) {
        super.init(nibName: nil, bundle: nil)
        
        self.mapView = mapView
        self.pickupPlace = pickupPlace
        self.destinationPlace = destinationPlace
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-330)
        self.mapView.padding = UIEdgeInsets.zero
        self.mapView.settings.myLocationButton = false
        self.mapView.isMyLocationEnabled = false
        self.mapView.isUserInteractionEnabled = false
        self.view.addSubview(self.mapView)
        self.addLocationsOnMap()
        
        self.selectRideAndPaymentView = SelectRideAndPaymentView(frame: CGRect(x: 0.0, y: self.view.frame.height-330.0, width: self.view.frame.width, height: 330.0))
        
        self.view.addSubview(self.selectRideAndPaymentView)
        
        self.backButton.setImage(UIImage(named: "back"), for: .normal)
        self.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(self.backButton)
    }
    
    func addLocationsOnMap() {
        
        if let pickupPlace = self.pickupPlace, let destinationPlace = self.destinationPlace {
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:\(pickupPlace.placeID)&destination=place_id:\(destinationPlace.placeID)&key=\(API_KEY)")!) { (data, urlResponse, error) in
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>, let routesArray = json["routes"] as? Array<Dictionary<String, Any>>, routesArray.count > 0, let infoArray = routesArray[0]["legs"] as? Array<Dictionary<String, Any>>, infoArray.count > 0 {
                            if let distanceDictionary = infoArray[0]["distance"] as? Dictionary<String, Any>, let distance = distanceDictionary["text"] as? String {
                                self.rideDistance = distance
                            }
                            if let durationDictionary = infoArray[0]["duration"] as? Dictionary<String, Any>, let duration = durationDictionary["text"] as? String {
                                self.rideDuration = duration
                            }
                            
                            DispatchQueue.main.async {
                                let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.calculateMarkerCoordinatesOnMapview), userInfo: nil, repeats: false)
                                timer.fire()
                                timer.invalidate()
                            }
                        }
                        
                    } catch {
                        
                    }
                }
            }
            task.resume()
            
            var bounds = GMSCoordinateBounds()
            
            self.pickupPlaceMarker = GMSMarker()
            self.pickupPlaceMarker!.icon = UIImage(named: "pickup")
            self.pickupPlaceMarker!.position = pickupPlace.coordinate
            self.pickupPlaceMarker!.title = pickupPlace.name
            self.pickupPlaceMarker!.map = mapView
            
            bounds = bounds.includingCoordinate(pickupPlace.coordinate)
            
            self.destinationPlaceMarker = GMSMarker()
            self.destinationPlaceMarker!.icon = UIImage(named: "destination")
            self.destinationPlaceMarker!.position = destinationPlace.coordinate
            self.destinationPlaceMarker!.title = destinationPlace.name
            self.destinationPlaceMarker!.map = mapView
            
            bounds = bounds.includingCoordinate(destinationPlace.coordinate)
            
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        }
        
    }
    
    func calculateMarkerCoordinatesOnMapview() {
        if let pickupPlaceMarker = self.pickupPlaceMarker, let destinationPlaceMarker = self.destinationPlaceMarker {
            let pickupPoint = self.mapView.projection.point(for: pickupPlaceMarker.position)
            let destinationPoint = self.mapView.projection.point(for: destinationPlaceMarker.position)
            
            self.drawLineBetween(pickupPoint: pickupPoint, andDestinationPoint: destinationPoint)
            
            self.drawCurveBetween(pickupPoint: pickupPoint, andDestinationPoint: destinationPoint)
            
            self.addIconViewsOnMarkers(pickupPoint: pickupPoint, andDestinationPoint: destinationPoint)
        }
    }
    
    func drawLineBetween(pickupPoint: CGPoint, andDestinationPoint destinationPoint: CGPoint) {
        let linePath = UIBezierPath()
        linePath.move(to: pickupPoint)
        linePath.addLine(to: destinationPoint)
        
        let linePathLayer = CAShapeLayer()
        linePathLayer.path = linePath.cgPath
        linePathLayer.strokeColor = UIColor.black.withAlphaComponent(0.075).cgColor
        linePathLayer.lineWidth = 4.0
        self.mapView!.layer.addSublayer(linePathLayer)
    }
    
    func drawCurveBetween(pickupPoint: CGPoint, andDestinationPoint destinationPoint: CGPoint) {
        
        let slope = -1/((destinationPoint.y - pickupPoint.y) / (destinationPoint.x - pickupPoint.x))
        
        let midPoint = CGPoint(x: (destinationPoint.x+pickupPoint.x)/2, y: (destinationPoint.y+pickupPoint.y)/2)
        
        let distance = sqrt(((destinationPoint.y - pickupPoint.y)*(destinationPoint.y - pickupPoint.y)) + ((destinationPoint.x - pickupPoint.x)*(destinationPoint.x - pickupPoint.x)))/4
        
        let x1 = midPoint.x + (distance / sqrt( (1 + (slope * slope) ) ) )
        let y1 = (slope*(x1-midPoint.x))+midPoint.y
        
        let x2 = midPoint.x - (distance / sqrt( (1 + (slope * slope) ) ) )
        let y2 = (slope*(x2-midPoint.x))+midPoint.y
        
        let controlPoint: CGPoint
        if slope < 0 {
            controlPoint = CGPoint(x: x1, y: y1)
        } else {
            controlPoint = CGPoint(x: x2, y: y2)
        }
        
        let circlePath = UIBezierPath()
        circlePath.move(to: pickupPoint)
        circlePath.addQuadCurve(to: destinationPoint, controlPoint: controlPoint)
        
        let curvePathLayer = CAShapeLayer()
        curvePathLayer.path = circlePath.cgPath
        curvePathLayer.fillColor = UIColor.clear.cgColor
        curvePathLayer.strokeColor = UIColor.black.cgColor
        curvePathLayer.lineWidth = 3.0
        self.mapView!.layer.addSublayer(curvePathLayer)
    }
    
    func addIconViewsOnMarkers(pickupPoint: CGPoint, andDestinationPoint destinationPoint: CGPoint) {
        
        if let pickupPlace = self.pickupPlace {
            let pickupLabel = UILabel()
            pickupLabel.font = UIFont.systemFont(ofSize: 12.0)
            pickupLabel.backgroundColor = UIColor.white
            pickupLabel.layer.shadowOffset = CGSize.zero
            pickupLabel.layer.shadowColor = UIColor.black.cgColor
            pickupLabel.layer.shadowRadius = 5.0
            pickupLabel.layer.shadowOpacity = 0.75
            pickupLabel.text = pickupPlace.name
            pickupLabel.sizeToFit()
            pickupLabel.frame.size = CGSize(width: pickupLabel.frame.width, height: 30)
            
            var x = pickupPoint.x
            if x + pickupLabel.frame.width > self.mapView!.frame.width {
                x = pickupPoint.x - pickupLabel.frame.width
            }
            
            var y = pickupPoint.y
            if y + pickupLabel.frame.height > self.mapView!.frame.height {
                y = pickupPoint.y - pickupLabel.frame.height
            }
            pickupLabel.frame.origin = CGPoint(x: x, y: y)
            
            self.mapView!.addSubview(pickupLabel)
        }
        
        if let destinationPlace = self.destinationPlace, let rideDuration = self.rideDuration {
            
            let destinationLabel = UILabel()
            destinationLabel.font = UIFont.systemFont(ofSize: 12.0)
            destinationLabel.backgroundColor = UIColor.white
            destinationLabel.layer.shadowOffset = CGSize.zero
            destinationLabel.layer.shadowColor = UIColor.black.cgColor
            destinationLabel.layer.shadowRadius = 5.0
            destinationLabel.layer.shadowOpacity = 0.75
            destinationLabel.text = destinationPlace.name
            destinationLabel.sizeToFit()
            destinationLabel.frame.size = CGSize(width: destinationLabel.frame.width, height: 30)
            
            let durationLabel = UILabel()
            durationLabel.font = UIFont.systemFont(ofSize: 11.0)
            durationLabel.backgroundColor = UIColor.black
            durationLabel.layer.shadowOffset = CGSize.zero
            durationLabel.layer.shadowColor = UIColor.black.cgColor
            durationLabel.layer.shadowRadius = 5.0
            durationLabel.layer.shadowOpacity = 0.75
            durationLabel.text = rideDuration
            durationLabel.textColor = UIColor.white
            durationLabel.textAlignment = .center
            durationLabel.numberOfLines = 2
            durationLabel.lineBreakMode = .byWordWrapping
            durationLabel.sizeToFit()
            durationLabel.frame.size = CGSize(width: 30, height: 30)
            
            var x = destinationPoint.x
            if x + destinationLabel.frame.width + 30 > self.mapView!.frame.width {
                x = destinationPoint.x - destinationLabel.frame.width - 30
            }
            
            var y = destinationPoint.y
            if y + destinationLabel.frame.height > self.mapView!.frame.height {
                y = destinationPoint.y - destinationLabel.frame.height
            }
            durationLabel.frame.origin = CGPoint(x: x, y: y)
            destinationLabel.frame.origin = CGPoint(x: x+durationLabel.frame.width, y: y)
            
            self.mapView!.addSubview(durationLabel)
            self.mapView!.addSubview(destinationLabel)
        }
    }

    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        for subView in self.mapView.subviews {
            subView.removeFromSuperview()
        }
        if let sublayers = self.mapView.layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        self.mapView.clear()
    }

}
