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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setLocalization()
//        self.backView.roundCorners([.topLeft,.topRight], radius: 30.0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func setLocalization(){
        self.lblChooselanguage.text =  "CHOOSE_PREFFERED".localized()
        self.lblSubTittelChooseLanhguage.text = "CHOOSE_YOUR_LAGUAGE_SUBTITTEL".localized()
//        self.lblEnglish.text = "ENGLISH".localized()
//        self.lblTittelDutch.text = "DUTCH".localized()
//        self.lblTittelGermen.text = "GERMAN".localized()
        self.btnNext.setTitle("NEXT".localized(), for: .normal)
    }
    
    
    @IBAction func btnEnglishOnPress(_ sender: UIButton) {
        self.imgEnglishCheck.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected")
        self.imgDutchCheck.image = #imageLiteral(resourceName: "tick_unselect")
        self.imgGermenCheck.image = #imageLiteral(resourceName: "tick_unselect")
        self.language = "en"
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
    
    @IBAction func btnGermenOnPress(_ sender: UIButton) {
        self.imgGermenCheck.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected")
        self.imgEnglishCheck.image = #imageLiteral(resourceName: "tick_unselect")
        self.imgDutchCheck.image = #imageLiteral(resourceName: "tick_unselect")
        self.language = "de"
        
    }
    @IBAction func btnDutchOnPress(_ sender: UIButton) {
        self.imgDutchCheck.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected")
        self.imgEnglishCheck.image = #imageLiteral(resourceName: "tick_unselect")
        self.imgGermenCheck.image = #imageLiteral(resourceName: "tick_unselect")
        self.language = "nl"
    }
}


extension LanguageVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableCell", for: indexPath) as! LanguageTableCell
        cell.lblLanguage.text = languageArray[indexPath.row]
        if selectedIndex == indexPath.row {
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
        self.tableView.reloadData()
    }
    
    
}
