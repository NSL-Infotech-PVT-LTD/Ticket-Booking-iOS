//
//  SearchArtistVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 28/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class SearchArtistVC: UIViewController {
    
   @IBOutlet weak var tblSearchArtist: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewCover: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblSearchArtist.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
    }
    
    @IBAction func btnFilterAction(_ sender: Any) {
        self.presentViewController(viewController: "FilterViewController", value: "Dashboard")
    }
 
}

extension SearchArtistVC :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomSearchArtistCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    
    
    
}

extension SearchArtistVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
        
        
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.tblSearchArtist.isHidden = false
        //delegate method
      textField.resignFirstResponder()

        return true
    }
}
