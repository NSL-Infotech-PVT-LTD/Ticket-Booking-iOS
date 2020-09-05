//
//  SelectAddressTypeVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 31/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class SelectAddressTypeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSelectOtherLocation(_ sender: UIButton) {
    }
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
