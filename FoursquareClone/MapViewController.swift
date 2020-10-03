//
//  MapViewController.swift
//  FoursquareClone
//
//  Created by Yurii Sameliuk on 16/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    // menedžer mestopoloženija polzowatelia
    var locationManager = CLLocationManager()
    
    var chosenLatitude = ""
    var chosenLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sozdaem prawyjy klawishy topBara
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonSelector))
        // sozdaem lewyjy klawishy topBara
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonSelector))
        
        mapView.delegate = self
        locationManager.delegate = self
        // ystanawliwaem želaemyjy to4nost s kakoj bydet ystanowleno mestopoloženije polzowatelia
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // zapros kogda polzowatel ispolzyet awtorizacujy
        locationManager.requestWhenInUseAuthorization()
        // zapysk slyžbu obnowlenija mestopoloženija
        locationManager.startUpdatingLocation()
        
        //yprawliaem kartoj pr pomos4i raspoznawatelia žestow
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocationSelector(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 3.0
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func chooseLocationSelector(gestureRecognizer:UILongPressGestureRecognizer) {
        // sokras4ennaja wersija - gestureRecognizer.state == .began
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            // sozdaem to4ky prikosnowenija
            let touches = gestureRecognizer.location(in: self.mapView)
            // peredaem tozky na karty
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String (coordinates.latitude)
            PlaceModel.sharedInstance.placelongitude = String(coordinates.longitude)
            
        }
        
    }
    
    @objc func saveButtonSelector() {
        //Parse
        
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Places", dictionary:
            ["name" : placeModel.placeName, "type" : placeModel.placeType, "atmosphere" : placeModel.placeAtmosphere, "latitude" : placeModel.placeLatitude, "longitude" : placeModel.placelongitude] )
        
            // proweriaem i dobawliaem izobražeije w bazy dannux
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpeg", data: imageData)
        }
        
        // delaem tak 4tobu dannue sochranialic w backgrounde
        object.saveInBackground { (success, error) in
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "error", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlaceVC", sender: nil)
            }
        }
        
    }
    
    @objc func backButtonSelector() {
        // wozwras4aemsia na predudys4ij kontroller, no eto ne bydet rabotat potomy 4to y nas w Main dwa NavigationViewController
       // navigationController?.popViewController(animated: true)
        
        // s dwymia NavigationViewController rabotaet etot sposob
        self.dismiss(animated: true, completion: nil)
        
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude)
        // esli pri poisky na karte postojanno wozwras4aet na tekys4yjy lokacujy , nyžno ostanowit opredelenije mestonachoždenije
        //locationManager.stopUpdatingLocation()
        
        // startowuj zyn kartu pri ee pojawlenii
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }

}
