//
//  AddPlaceViewController.swift
//  FoursquareClone
//
//  Created by Yurii Sameliuk on 16/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeTypeTextField: UITextField!
    @IBOutlet weak var placeAtmosphereTextField: UITextField!
    
    @IBOutlet weak var imageVeiw: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageVeiw.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage))
        view.addGestureRecognizer(gestureRecognizer)

       
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageVeiw.image = info[.originalImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if placeNameTextField.text != "" && placeAtmosphereTextField.text != "" {
            if let chosenImage = imageVeiw.image {
                // ispolzyem klas singlton
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameTextField.text!
                placeModel.placeType = placeTypeTextField.text!
                placeModel.placeAtmosphere = placeAtmosphereTextField.text!
                placeModel.placeImage = chosenImage

            }
            
                  performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Place/Type/Atmosphere??" , preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
}
