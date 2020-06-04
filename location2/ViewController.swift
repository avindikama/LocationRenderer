//
//  ViewController.swift
//  location2
//
//  Created by Azamat Igiman on 5/23/20.
//  Copyright © 2020 Azamat Igiman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreMotion
class ViewController: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate{
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var labelLatitude: UILabel!
    @IBOutlet weak var labelLogitude: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var pedo = CMPedometerData()
    var pedoManager = CMMotionManager()
    var pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.activityType = .fitness
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        map.delegate = self
       // createLine()
       
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    
        
    pedofunc()
        //print ("This is pedo start date",pedo.startDate)

}
    @objc func fireTimer() {
        print("Timer fired!")
         print (pedo.distance  ,"this is distance traveled")
        print (pedo.currentPace  ,"this is pace")
        createLine()
    }
    
    
    
    func pedofunc(){ pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
             if let pedData = pedometerData{
                  print( pedData.numberOfSteps)
             } else {
                    print("Steps: Not Available")
             }
    })}
    
    var locationsArray = [
//        CLLocationCoordinate2D(latitude: 34.090715, longitude: -118.284585),
//       CLLocationCoordinate2D(latitude: 34.089101, longitude: -118.377676),
//        CLLocationCoordinate2D(latitude: 34.037690, longitude: -118.376605),
//     CLLocationCoordinate2D(latitude: 34.038743, longitude: -118.285035),
//     CLLocationCoordinate2D(latitude: 34.090715, longitude: -118.284585),
        CLLocationCoordinate2D
        ]()
    
    var distanceTraveled = CLLocationDistance()
    func updateDistance(){
        distanceLabel.text = "Distance:\(distanceTraveled) meters"
    }
    
    func createLine(){
//        let locations = [
//            CLLocationCoordinate2D(latitude: 34.090715, longitude: -118.284585),
//           CLLocationCoordinate2D(latitude: 34.089101, longitude: -118.377676),
//            CLLocationCoordinate2D(latitude: 34.037690, longitude: -118.376605),
//         CLLocationCoordinate2D(latitude: 34.038743, longitude: -118.285035),
//         CLLocationCoordinate2D(latitude: 34.090715, longitude: -118.284585),
//        ]
        let aPolyLine = MKPolyline(coordinates: locationsArray, count: locationsArray.count)
        map.addOverlay(aPolyLine)
        
        if locationsArray.count>20 {
            let size = locationsArray.count
            
            let point1 = MKMapPoint(locationsArray[size-1])
            let point2 = MKMapPoint(locationsArray[size-2])
            distanceTraveled = distanceTraveled +
            point1.distance(to: point2)
            
            updateDistance()
        }
    }
    
   
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print ("this is ot - ", locations.last)
//        labelLatitude.text = "Latitude: \(locations.last?.coordinate.latitude)"
//         labelLogitude.text = "Latitude: \(locations.last?.coordinate.longitude)"
        locationsArray.append( CLLocationCoordinate2D(latitude: (locations.last?.coordinate.latitude)!, longitude: (locations.last?.coordinate.longitude)!))
        createLine()
   
    }
    
    
}

extension ViewController {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .black
    renderer.lineWidth = 3
    return renderer
  }
}
