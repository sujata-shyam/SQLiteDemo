//
//  ThirdViewController.swift
//  FavouriteActors
//
//  Created by Sujata on 12/05/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    var selectedActor:actorData? = nil //Value passed from prev. View Controller
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let _ = selectedActor{
            loadValues()
        }
    }
    
    func loadValues(){
        
        if let imagestring = selectedActor?.avatar {
            if let imageUrl = URL(string: imagestring) {
                imageview?.load(url: imageUrl)
            }
        }
        
        if let firstName = selectedActor?.first_name, let lastName = selectedActor?.last_name {
            labelName.text = "\(firstName) \(lastName)"
        }
       
        if let email = selectedActor?.email {
            labelEmail.text = email
        }
    }
    
    @IBAction func btnSelect_Tapped(_ sender: UIButton) {
        btnSelect.setImage(UIImage(named: "UnfavStar"), for: .normal)
        arrData.removeAll { $0.id == selectedActor?.id }
        deleteData(id: (selectedActor?.id)!)
        
    }
}
