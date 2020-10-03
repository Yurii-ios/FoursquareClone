//
//  DetalisViewController.swift
//  FoursquareClone
//
//  Created by Yurii Sameliuk on 16/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import MapKit
import Parse

class DetalisViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeAtmosphereLabel: UILabel!
    
    @IBOutlet weak var detalisMapView: MKMapView!
    
    var chosenPlaceId = ""
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detalisMapView.delegate = self
        getDataFromParse()
        
    }
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        // wupolniaem asinchronnuj priem dannuch. wse dannue kotorue w rezyltate mu poly4aem zdes, pri wuzowe wne etoj funkcii otobražatsis ne bydyt
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                
            } else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        
                        // OBJECTS
                        
                        
                        
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                            self.placeNameLabel.text = placeName
                        }
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                            self.placeTypeLabel.text = placeType
                        }
                        if let atmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            self.placeAtmosphereLabel.text = atmosphere
                        }
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { (data, error) in
                                if error == nil {
                                    if data != nil {
                                        self.imageView.image = UIImage(data: data!)
                                    }
                                    
                                }
                            }
                        }
                        
                        //MAPS
                        let location = CLLocationCoordinate2DMake(self.chosenLatitude, self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.detalisMapView.setRegion(region, animated: true)
                        
                        //Annotations
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.placeNameLabel.text!
                        annotation.subtitle = self.placeTypeLabel.text!
                        self.detalisMapView.addAnnotation(annotation)
                    }
                    
                }
            }
        }
    }
    // sozdaemknopky s informacuej na annotacii
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    // opredeliaem 4to proizojdet kogda polzowatel nažmet na knopky info  w annoracii
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
           // preobrazyem nazwanija mest w koordinatu
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        
                        let mkplaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkplaceMark)
                        mapItem.name = self.placeNameLabel.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                }
            }
        }
    }
    
}
