//
//  MapKitViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController, MKMapViewDelegate {
    
       
    @IBOutlet weak var mapView: MKMapView!
    var parseStudentLocations = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        OTMap_Tasks.sharedInstance().loadStudentLocations(completionHandlerForLocations: { (success,results,errorString) in
            
            performUpdatesOnMainQueue {
                
                if success {
                    print("success",success)
                    let parseStudentLocations = results
                    
                    var annotations = [MKPointAnnotation]()
                    
                    for dictionary in parseStudentLocations {
                        let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                        let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                        
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let first = dictionary["firstName"] as! String
                        let last = dictionary["lastName"] as! String
                        let medidaURL = dictionary["mediaURL"] as! String
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = medidaURL
                        print("!!Hello THERE!")
                        annotations.append(annotation)
                        
                    }
                    self.mapView.addAnnotations(annotations)
                    print("")
                    print("****annotations*****",annotations,annotations.count)
                    print("")
                    
                } else {
                    print("error line 65 MapKit",errorString  ?? 0)
                }
            }
        })
    }
    
       
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}

