//
//  FirstViewController.swift
//  FavouriteActors
//
//  Created by Sujata on 12/05/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit
import SQLite3

class FirstViewController: UIViewController {

    @IBOutlet weak var tableViewActors: UITableView!
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            
        tableViewActors.dataSource = self
        tableViewActors.delegate = self
        
        startActivityIndicator(vc: self)
        
        loadActorsData() //Loading json data
        
        openDatabase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async
        {
            self.tableViewActors.reloadData()
        }
    }
    
    //MARK: - Loading JSON Data
    func loadActorsData() {
        let url = URL(string: urlMainString)
        
        if let url = url{
            let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
                guard let data =  data else { print("URLSession not workig")
                    return }
                do {
                    let dictData = try JSONDecoder().decode(completeData.self, from: data)
                    
                    if(dictData.data!.count > 0) {
                        arrData = Array(dictData.data!)
                        DispatchQueue.main.async {
                            self.tableViewActors.reloadData()
                            stopActivityIndicator(vc: self)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            displayAlert(vc: self, title: "", message: "Sorry.No data available.")
                        }
                    }
                    
                }
                catch {
                    DispatchQueue.main.async {
                        stopActivityIndicator(vc: self)
                    }
                    print("error:\(error)")
                }
            }
            task.resume()
        }
    }

}

extension FirstViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - TableView Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrData.count > 0 { return arrData.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorsTableViewCell", for: indexPath)
        
        let fullName = "\(arrData[indexPath.row].first_name ?? " ") \(arrData[indexPath.row].last_name ?? " ")"
        
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = arrData[indexPath.row].email
        
        if let _ = arrData[indexPath.row].isFav{}
            else{
                arrData[indexPath.row].isFav = false
        }
        
        if let imagestring = arrData[indexPath.row].avatar {
            if let imageUrl = URL(string: imagestring) {
                cell.imageView?.load(url: imageUrl)
            }
        }
        
        let starImageView = UIImageView(image: UIImage(named: "UnfavStar"))
        cell.accessoryView = starImageView;
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        var actorItem = arrData[indexPath.row]
        actorItem.isFav = !actorItem.isFav!
        
        arrData[indexPath.row].isFav = actorItem.isFav
        
        toggleCellCheckbox(cell, isFav: actorItem.isFav!, indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isFav: Bool, indexPath: IndexPath)
    {
        let starImageView = UIImageView(image: UIImage(named: "Star"))
        let unStarImageView = UIImageView(image: UIImage(named: "UnfavStar"))
        
        if !isFav {
            deleteData(id: arrData[indexPath.row].id!)
            cell.accessoryView = unStarImageView;
        }
        else {
            insertData(id: arrData[indexPath.row].id!, firstName: arrData[indexPath.row].first_name!, secondName: arrData[indexPath.row].last_name!, email: arrData[indexPath.row].email!, imageurl: arrData[indexPath.row].avatar!)
            
            cell.accessoryView = starImageView;
        }
    }
}
