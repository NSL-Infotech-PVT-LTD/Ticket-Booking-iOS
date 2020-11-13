//
//  LanguageVC.swift
//  SurpriseMe_Artist
//
//  Created by Apple on 04/11/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class LanguageTableCell: UITableViewCell{
    
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
}


class LanguageVC: UIViewController {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgGermenCheck: UIImageView!
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var imgDutchCheck: UIImageView!
    @IBOutlet weak var imgEnglishCheck: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblTittelGermen: UILabel!
    @IBOutlet weak var lblTittelDutch: UILabel!
    @IBOutlet weak var lblChooselanguage: UILabel!
    @IBOutlet weak var lblSubTittelChooseLanhguage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var language = "en"
    var languageArray = ["English (US)","Dutch","German","Spanish"]
    var languageCodeArray = ["en","nl","de","es"]
    var selectedIndex = 0
   var selectedLanguage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        

       
        
        let language = UserDefaults.standard.value(forKey: "app_lang") as? String ?? ""
        if language == "en"{
            self.lblChooselanguage.text =  "CHOOSE_PREFFERED".localized()
            self.lblSubTittelChooseLanhguage.text = "CHOOSE_YOUR_LAGUAGE_SUBTITTEL".localized()
            
            let languageValue = UserDefaults.standard.value(forKey: "Selected") as? String ?? ""

                   if languageValue == "1"{
                       self.btnNext.setTitle("CHANGE", for: .normal)

                   }else{
                       self.btnNext.setTitle("next".localized(), for: .normal)

                   }
            
            self.language = "en"
            
        }else if language == "nl" {
            self.lblChooselanguage.text =  "CHOOSE_PREFFERED".localized()
            self.lblSubTittelChooseLanhguage.text = "CHOOSE_YOUR_LAGUAGE_SUBTITTEL".localized()
            self.btnNext.setTitle("next".localized(), for: .normal)
            self.language = "nl"
            
        }else if language == "es"{
            self.lblChooselanguage.text =  "CHOOSE_PREFFERED".localized()
            self.lblSubTittelChooseLanhguage.text = "CHOOSE_YOUR_LAGUAGE_SUBTITTEL".localized()
            self.btnNext.setTitle("next".localized(), for: .normal)
            self.language = "es"
            
            
        }else if language == "de"{
            self.lblChooselanguage.text =  "CHOOSE_PREFFERED".localized()
            self.lblSubTittelChooseLanhguage.text = "CHOOSE_YOUR_LAGUAGE_SUBTITTEL".localized()
            self.btnNext.setTitle("next".localized(), for: .normal)
            self.language = "de"
            
        }else{
            self.lblChooselanguage.text =  "CHOOSE_PREFFERED".localized()
            self.lblSubTittelChooseLanhguage.text = "CHOOSE_YOUR_LAGUAGE_SUBTITTEL".localized()
            self.btnNext.setTitle("next".localized(), for: .normal)
            self.language = "en"
        }
        
    }
    
    @IBAction func btnNextOnPress(_ sender: UIButton) {
        if language == "" || language.isEmpty == true{
            //            self.view.makeToast("CHOOSE_PREFFERED_TOAST".localized(), duration: 2.0, position: .bottom)
        }else{
            Bundle.setLanguage(lang: language)
            UserDefaults.standard.setValue(language, forKey: "app_lang")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension LanguageVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableCell", for: indexPath) as! LanguageTableCell
        cell.lblLanguage.text = languageArray[indexPath.row]
        
        let selectIndex = UserDefaults.standard.value(forKey: "SelectedIndex") as? Int ?? 0
        
      if selectIndex == indexPath.row {
            cell.imgCheck.image = #imageLiteral(resourceName: "tick")
        }else{
            cell.imgCheck.image = #imageLiteral(resourceName: "tick_unselect")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languageCodeArray[indexPath.row]
        self.language = language
        self.selectedIndex = indexPath.row
        
        UserDefaults.standard.setValue(indexPath.row, forKey: "SelectedIndex")

        UserDefaults.standard.setValue("1", forKey: "Selected")

        
        self.tableView.reloadData()
        
       
        
        
    }
    
    
}
