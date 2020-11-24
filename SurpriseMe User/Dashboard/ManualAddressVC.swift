//
//  ManualAddressVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 31/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import Alamofire

class ManualAddressVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblManualAddress: UITableView!
    @IBOutlet weak var searchTf: UITextField!
    
    //MARK:- Variable -
    var arrayAddress = [String]()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()
        let view = UIView()
        self.tblManualAddress.tableFooterView = view
        self.arrayAddress.removeAll()
        self.searchTf.text = nil
        self.tblManualAddress.reloadData()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
    }
    
        
        func getAutoSuggestName(searchName : String)  {
            let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchName)&types=establishment|geocode&location=%@,%@&radius=500&language=en&key=AIzaSyAeRjBp9uCEHLe-dIdsGVKegO9KzsmHmwA"

    
           
          
            let defaultConfigObject = URLSessionConfiguration.default
            
            let urlStringaa = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            
            print(urlStringaa)

            let url = URL(string: urlStringaa)!

            _ = URL.init(string: urlString)
            let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
            let request = NSURLRequest(url: url as URL)
            let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
            {
                (data, response, error) -> Void in
                if let data = data
                {
                    do {
                        let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                       
                        
                        
                        let status = jSONresult["status"] as! String
                        if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                        {
                           
                            return
                        }
                        else
                        {
                            let results = jSONresult["predictions"] as! [[String:Any]]
                            self.arrayAddress.removeAll()
                                                   print(results)
                                                   
                                                   for index in results{
                                                       print(index["description"] ?? "")
                                                       self.arrayAddress.append(index["description"] as! String )
                                                   }
                                                   
                            self.tblManualAddress.reloadData()
                            
    //                        completion(results)
                        }
                    }
                    catch
                    {
                        print("json error: \(error)")
                    }
                }
                else if let error = error
                {
                    print(error)
                }
            })
            task.resume()

        }

    
}


extension ManualAddressVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomManualAddressCell
        let addressData = arrayAddress[indexPath.row]
        cell.lblAddress.text = addressData
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                      let controller = storyboard.instantiateViewController(withIdentifier: "UpdateLocationVC") as! UpdateLocationVC
        
        cameFrom = true
        controller.addressSelected = self.arrayAddress[indexPath.row]
                      navigationController?.pushViewController(controller, animated: false)
    }
    
    
}

extension ManualAddressVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.getAutoSuggestName(searchName : self.searchTf.text! + string)
        return true;
    }
}
