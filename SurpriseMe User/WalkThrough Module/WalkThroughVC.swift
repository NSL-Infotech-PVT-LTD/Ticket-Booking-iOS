//
//  WalkThroughVC.swift
//  SurpriseMe User
//


import UIKit

class WalkThroughVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnGetStarted: UIButton!
    
    //MARK:- Variable -
    var imgArray = ["WalkThrough1","WalkThrough2","WalkThrough3"]
    var arrayHeader = ["Birthday Surprise","Dj Performers","Digital Performers"]
    var arrayDescHeader = ["Lorem Ipsum is simply dummy text of theprinting and typesetting industry. LoremIpsum has been the industry's standard dummy text ever","Dj Performers","Digital Performers"]

    var navigationControl = UINavigationController()
    var timer = Timer()
    var counter = 0
    
    
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
        self.setAutoScroll()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnGetStartedAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func changeImages() {
        if counter < imgArray.count {
            let index = IndexPath(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            let index = IndexPath(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
    }
    
    func setAutoScroll()  {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImages), userInfo: nil, repeats: true)
        }
    }

    
}

//MARK:- Extension for collection view -
extension WalkThroughVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomWalkThroughCell
        cell.imgWalkThrough.image = UIImage.init(named: imgArray[indexPath.row])
        cell.lblTitleWalkThrough.text = arrayHeader[indexPath.row]
        cell.heightConstant.constant = view.frame.size.height
        //        cell.widthConstant.constant = collectionView.frame.size.width
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: collectionView.frame.size.width, height:  collectionView.frame.size.height)
    }
    
    
    
}
