//
//  PlaceListVC.swift
//  FoursquareCloneFirebase
//
//  Created by Barış Genç on 15.05.2021.
//  Copyright © 2021 BG. All rights reserved.
//

import UIKit
import Firebase

class PlaceListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var nameArray = [String]()
    var idArray = [String]()
    var selectedPlaceName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPlace))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutClicked))
       
        getData()
    }
    
    func getData() {
        
        db.collection("FourSquare").addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
            } else {
                if snapshot?.isEmpty != true {
                    self.nameArray.removeAll(keepingCapacity: false)
                    self.idArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.idArray.append(documentId)
                        if let name = document.get("placeName") as? String {
                                self.nameArray.append(name)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func logoutClicked() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("error")
        }
    }
    
    @objc func addNewPlace() {
        //Segue
        performSegue(withIdentifier: "toAddDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            db.collection("FourSquare").document(self.idArray[indexPath.row]).delete { (error) in
            if error == nil {
                self.nameArray.remove(at: indexPath.row)
                self.idArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    print("error")
                }
            }
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowDetailsVC" {
            let vc = segue.destination as! ShowDetailsVC
            vc.chosenPlaceName = selectedPlaceName
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceName = nameArray[indexPath.row]
        performSegue(withIdentifier: "toShowDetailsVC", sender: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        present(alert, animated: true, completion: nil)
    }
}
