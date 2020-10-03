//
//  PlacesViewController.swift
//  FoursquareClone
//
//  Created by Yurii Sameliuk on 16/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Parse

class PlacesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // sozdaem masiwu dlia poly4enija dannux iz bazu dannux
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButton))

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFronParse()
  
    }
    
    @objc func addButton() {
        // Segue
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
        
    }
    @objc func logoutButton() {
        //logout user
        PFUser.logOutInBackground { (error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                
            } else {
                
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
    }
    
    func getDataFronParse() {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
            } else {
                if objects != nil {
                    
                    // o4is4aem masiwu pered zapolneniem nowumi dannumi 4tobu predotwratit dyblirowanie
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                            
                        }
                        
                    }
                    // posle cukla for obnowliaem predstawlenie talicu
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! DetalisViewController
            destinationVC.chosenPlaceId = selectedPlaceId
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        
        return cell
    }
    
    func makeAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
                 let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                 alert.addAction(action)
                 self.present(alert, animated: true, completion: nil)
    }
}
