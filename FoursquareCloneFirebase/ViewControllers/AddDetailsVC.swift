//
//  AddDetailsVC.swift
//  FoursquareCloneFirebase
//
//  Created by Barış Genç on 15.05.2021.
//  Copyright © 2021 BG. All rights reserved.
//

import UIKit

class AddDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var placeNameField: UITextField!
    @IBOutlet weak var placeTypeField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage))
        imageView.addGestureRecognizer(gestureRecognizer)
       
    }
    
    @objc func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if placeNameField.text != "" && placeTypeField.text != "" && description != "" {
            if let chosenImage = imageView.image {
                PlaceModel.sharedInstance.placeName = placeNameField.text!
                PlaceModel.sharedInstance.placeType = placeTypeField.text!
                PlaceModel.sharedInstance.description = descriptionField.text!
                PlaceModel.sharedInstance.image = chosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Place name/Type/Description??", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
