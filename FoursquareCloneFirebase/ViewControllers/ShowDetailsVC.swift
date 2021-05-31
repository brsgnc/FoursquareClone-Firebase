//
//  ShowDetailsVC.swift
//  FoursquareCloneFirebase
//
//  Created by Barış Genç on 17.05.2021.
//  Copyright © 2021 BG. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import SDWebImage

class ShowDetailsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceName = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsMapView.delegate = self
        
        getData()
    }
    
    func getData() {
    let db = Firestore.firestore()
    db.collection("FourSquare").whereField("placeName", isEqualTo: chosenPlaceName).getDocuments{ (snapshot, error) in
        if error != nil {
            print("Error")
        } else {
            if snapshot != nil {
                let chosenObject = snapshot!.documents[0]
               // for document in snapshot!.documents {
                    if let placeName = chosenObject.get("placeName") as? String {
                        self.placeNameLabel.text = placeName
                    }
                    if let placeType = chosenObject.get("placeType") as? String {
                        self.placeTypeLabel.text = placeType
                    }
                    if let description = chosenObject.get("description") as? String {
                        self.descriptionLabel.text = description
                    }
                    if let placeLatitude = chosenObject.get("placeLatitude") as? Double {
                        self.chosenLatitude = placeLatitude
                    }
                    if let placeLongitude = chosenObject.get("placeLongitude") as? Double {
                        self.chosenLongitude = placeLongitude
                    }
                    if let imageUrl = chosenObject.get("imageurl") as? String {
                        self.detailsImageView.sd_setImage(with: URL(string: imageUrl))
                    }
                    
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.detailsMapView.setRegion(region, animated: true)
                
                    let annotation = MKPointAnnotation()
                    annotation.title = self.placeNameLabel.text
                    annotation.subtitle = self.placeTypeLabel.text
                    annotation.coordinate = location
                    self.detailsMapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let pinId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if chosenLatitude != 0.0 && chosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: mkPlacemark)
                        item.name = self.placeNameLabel.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}


    

   


