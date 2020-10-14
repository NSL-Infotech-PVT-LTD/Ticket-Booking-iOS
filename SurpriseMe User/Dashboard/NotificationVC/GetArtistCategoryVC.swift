//
//  GetArtistCategoryVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 17/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

class GetArtistCategoryVC: UIViewController {

    
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var seachTF: UITextField!
    
    
    var arrayGetCategory = [GetArtistCategoryModel]()
    
    
    //MARK:- Variable -
    var objectModelView = GetArtistCategoryViewModel()
//    var modelObect = []()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let view = UIView()
        tblCategory.tableFooterView = view
        
        self.objectModelView.delegate = self
        let dictParam = ["search":"","limit":"20"]
        self.objectModelView.geArtistCategoryData(param: dictParam)
        
        
        
    }
    
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.back()

    }
    
    @IBAction func tnBackAction(_ sender: UIButton) {
        self.back()
    }
    


}

extension GetArtistCategoryVC :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayGetCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomArtistCategoryCell
        let dataItem = arrayGetCategory[indexPath.row]
        cell.lblCat.text = dataItem.name ?? ""
        
        if arrayCategorySelected.contains(arrayGetCategory[indexPath.row].id ?? 0) {
            cell.imgCheck.image = UIImage(named: "tick_selected")
        }
        else {
            cell.imgCheck.image = UIImage(named: "tick_unselect")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayCategorySelected.count > 0{
            if arrayCategorySelected.contains(arrayGetCategory[indexPath.row].id ?? 0)
                {
                    let indexOfB = arrayCategorySelectedName.firstIndex(of: arrayGetCategory[indexPath.row].name ?? "")
                    let indexOfA = arrayCategorySelected.firstIndex(of: arrayGetCategory[indexPath.row].id ?? 0)
                    arrayCategorySelected.remove(at: indexOfA ?? 0)
                    arrayCategorySelectedName.remove(at: indexOfB ?? 0)
                    
                }else{
                    arrayCategorySelected.append(arrayGetCategory[indexPath.row].id ?? 0)
                    arrayCategorySelectedName.append(arrayGetCategory[indexPath.row].name ?? "")
                }
            }else{
            arrayCategorySelected.append(arrayGetCategory[indexPath.row].id ?? 0)
                arrayCategorySelectedName.append(arrayGetCategory[indexPath.row].name ?? "")
            }
            print(arrayCategorySelected)
            tblCategory.reloadData()
        }
       
    
    
}

extension GetArtistCategoryVC :GetArtistCategoryViewModelDelegate{
    func fetArtistCategoryApiResponse(message: String, response: [GetArtistCategoryModel], isError: Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            arrayGetCategory = response.map({$0})
            print("the category array is \(arrayGetCategory.count)")
            self.tblCategory.reloadData()
        }
    }
    
   
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    
    
}
