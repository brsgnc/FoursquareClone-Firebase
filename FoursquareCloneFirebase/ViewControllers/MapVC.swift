//
//  MapVC.swift
//  FoursquareCloneFirebase
//
//  Created by Barış Genç on 15.05.2021.
//  Copyright © 2021 BG. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))

        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func chooseLocation(gesturerecognizer: UIGestureRecognizer) {
        if gesturerecognizer.state == .began {
            let touchedPoints = gesturerecognizer.location(in: mapView)
            let coordinates = mapView.convert(touchedPoints, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.chosenLatitude = coordinates.latitude
            PlaceModel.sharedInstance.chosenLongitude = coordinates.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    

    @objc func saveButtonClicked() {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageFolder = storageRef.child("PlaceImage")
        
        if let data = PlaceModel.sharedInstance.image.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageRef = imageFolder.child("\(uuid).jpg")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageRef.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            let db = Firestore.firestore()
                            let placeArray = ["placeName": PlaceModel.sharedInstance.placeName, "placeType": PlaceModel.sharedInstance.placeType, "placeLatitude": PlaceModel.sharedInstance.chosenLatitude, "placeLongitude": PlaceModel.sharedInstance.chosenLongitude, "description": PlaceModel.sharedInstance.description, "imageurl": imageUrl!] as [String : Any]
                            db.collection("FourSquare").addDocument(data: placeArray) { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    self.performSegue(withIdentifier: "mapVCtoPlaceListVC", sender: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
  
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        present(alert, animated: true, completion: nil)
    }
}
