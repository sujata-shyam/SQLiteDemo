//
//  SecondViewController.swift
//  FavouriteActors
//
//  Created by Sujata on 12/05/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var tableViewFavActors: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewFavActors.delegate = self
        tableViewFavActors.dataSource = self
        
        readValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        readValues()
        DispatchQueue.main.async {
            self.tableViewFavActors.reloadData()
        }
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - TableView Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrFavActor.count > 0
        {
           return arrFavActor.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favActorsTableViewCell", for: indexPath)
        
        let fullName = "\(arrFavActor[indexPath.row].first_name ?? " ") \(arrFavActor[indexPath.row].last_name ?? " ")"
        
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = arrFavActor[indexPath.row].email
        
        if let imagestring = arrFavActor[indexPath.row].avatar {
            if let imageUrl = URL(string: imagestring) {
                cell.imageView?.load(url: imageUrl)
            }
        }
        
        let starImageView = UIImageView(image: UIImage(named: "Star"))
        let unStarImageView = UIImageView(image: UIImage(named: "UnfavStar"))
        
        if let isFavourite = arrFavActor[indexPath.row].isFav
        {
            if isFavourite{
                cell.accessoryView = starImageView
            }
            else{
                cell.accessoryView = unStarImageView
            }
        }
        else
        {
            cell.accessoryView = unStarImageView
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToThirdView", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let thirdVC = segue.destination as? ThirdViewController
        {
            if let indexPath = tableViewFavActors.indexPathForSelectedRow
            {
                thirdVC.selectedActor = arrFavActor[indexPath.row]
            }
        }
    }
}
