//
//  ViewProfileVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 26/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

//    class globalVariable: NSObject {
//        static var profile = GetProfileModel()
//    }

import UIKit
import SDWebImage
import NVActivityIndicatorView
import YoutubePlayer_in_WKWebView
import AVKit
import AVFoundation
import youtube_ios_player_helper
import Cosmos
import SwiftyJSON
import ImageSlideshow


class imageSLiderCell :UICollectionViewCell{
    @IBOutlet weak var imageWIdth: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
}

class ViewProfileVC: UIViewController , UIScrollViewDelegate {
    
    //MARK:- Outlets -
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var imageSliderCollection: UICollectionView!
    @IBOutlet weak var imageSliderCollectionContainer: UIView!
    @IBOutlet weak var crossBack: UIView!
    @IBOutlet weak var showCollectionView: UICollectionView!
    @IBOutlet weak var serviceCollectionView: UICollectionView!
  @IBOutlet weak var imgVirtualShowType: UIImageView!
    @IBOutlet weak var serviceCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLiveShow: UIView!
    @IBOutlet weak var viewDigitalShow: UIView!
    @IBOutlet weak var novideoLbl: UILabel!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var imgViedoPlay: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgProfileYoutube: UIImageView!
    @IBOutlet weak var imgProfileInsta: UIImageView!
    
    
    @IBOutlet weak var reportTxtViewValue: UITextView!
    
    @IBOutlet weak var viewReportTxtView: UIView!
    
    
    @IBOutlet weak var viewReportContainer: UIView!
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var lblInstaLink: UILabel!
    @IBOutlet weak var lblYoutubeLink: UILabel!
    @IBOutlet var viewContainerPreview: UIView!
    @IBOutlet var imgViewUserPreview: UIImageView!
    @IBOutlet weak var dashlineView: UIImageView!
    @IBOutlet weak var lblGallery: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLiveShowPrice: UILabel!
    @IBOutlet weak var lblDigitalShowPrice: UILabel!
    @IBOutlet weak var lblYoutubeSubscribers: UILabel!
    @IBOutlet weak var lblInstagramSubscribers: UILabel!
    @IBOutlet weak var txtViewAbout: UITextView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var btnCrossImage: UIButton!
    @IBOutlet weak var youTubePlayer: YTPlayerView!
    @IBOutlet weak var lblNewBrandArtist: UILabel!
    @IBOutlet weak var viewInstaGramProfile: UIView!
    @IBOutlet weak var imgSliderShowView: ImageSlideshow!
    @IBOutlet weak var imgPlayBtnVideo: UIImageView!
    @IBOutlet weak var playVideoBtn: UIButton!
    @IBOutlet weak var digitalShowHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var lblBookingPrice: UILabel!
    @IBOutlet weak var lblVirtual: UILabel!
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblSocialMedia: UILabel!
    
  @IBOutlet weak var viewProfile12: UILabel!
    @IBOutlet weak var viewProfile: UILabel!
    @IBOutlet weak var lblInstaAccount: UILabel!
    @IBOutlet weak var lblYoutubeAccount: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    
    @IBOutlet weak var lblChatAboutBooking: UILabel!
    
    
    @IBOutlet weak var liveShowHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var imgShowType: UIImageView!
    @IBOutlet weak var btnSeeReview: UIButton!
    @IBOutlet weak var viewSocilaLoginContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainerSocialLoginView: UIView!
    @IBOutlet weak var viewLivePriceValue: UIView!
    @IBOutlet weak var lblInPersonData: UILabel!
    @IBOutlet weak var viewYoutubeProfile: UIView!
    @IBOutlet weak var viewImageViewContainer: UIView!
    @IBOutlet weak var viewCosmoRating: CosmosView!
    //MARK:- Variable -
    var getProfileVMObject = GetArtistProfileViewModel()
    var getArtistProfile : GetArtistModel?
    var youtubeImageUrl = String()
    var youtubeID = String()
    var VideoLink = String()
    var photo = [UIImage]()
    let mainScrollView = UIScrollView()
    var imageArrayValue = [String]()
    let pageControlData = UIPageControl()
    var isSliderShow = false
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var localVideoUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.imgProfile.isUserInteractionEnabled = true
        self.imgProfile.addGestureRecognizer(tap)
        let tap12 = UITapGestureRecognizer(target: self, action: #selector(imageTappedtap12))
        self.viewInstaGramProfile.isUserInteractionEnabled = true
        self.viewInstaGramProfile.addGestureRecognizer(tap12)
        let tap13 = UITapGestureRecognizer(target: self, action: #selector(imageTappedtap13))
        self.viewYoutubeProfile.isUserInteractionEnabled = true
        self.viewYoutubeProfile.addGestureRecognizer(tap13)
        
        self.viewBack.addBottomShadow()
        self.imageSliderCollectionContainer.isHidden = true
        imgViewUserPreview.isHidden = false
        
        getProfileVMObject.delegate = self //Mark: Delegate call
        //Mark:Api Hitp
        let dictParam = ["id":userArtistID]
        getProfileVMObject.getProfileData(param:dictParam)
        novideoLbl.isHidden = true
        viewContainerPreview.isHidden = true
        imgViewUserPreview.isHidden = true
        viewReportContainer.isHidden = true
        btnCrossImage.isHidden = true
        crossBack.isHidden = true
        self.viewReportTxtView.isHidden = true
        viewImageViewContainer.isHidden = true
        //Mark: CollectionView Delegate
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        imageSliderCollection.delegate = self
        imageSliderCollection.dataSource = self
        self.serviceCollectionView.reloadData()
        showCollectionView.delegate = self
        showCollectionView.dataSource = self
        self.showCollectionView.reloadData()
        
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func colletionImg() {
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth), height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        imageSliderCollection!.collectionViewLayout = layout
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        imgPlayBtnVideo.isHidden = true
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [])
        }
        catch {
        }
        
        let tapviewAboutUs = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewAboutUs(_:)))
        imgProfile.addGestureRecognizer(tapviewAboutUs)
    }
    @IBAction func btnCrossProfileAction(_ sender: UIButton) {
        viewContainerPreview.isHidden = true
        imgViewUserPreview.isHidden = true
        btnCrossImage.isHidden = true
        crossBack.isHidden = true
        viewImageViewContainer.isHidden = true
    }
    
    
    
    @IBAction func btnSubmitReportAction(_ sender: UIButton) {
        
        if reportTxtViewValue.text == "" || reportTxtViewValue.text == "WRITE_YOUR_REASON".localized(){
            Helper.showOKAlert(onVC: self, title: "Alert", message: "Please enter your reason")
            
        }else{
            self.reportArtist(artistID: userArtistID, reason: reportTxtViewValue.text)
            self.viewReportContainer.isHidden = true
            self.viewReportTxtView.isHidden = true
            self.reportTxtViewValue.resignFirstResponder()
        }
        
        
        
        
        
    }
    
    @IBAction func btnCancelReportViewAction(_ sender: UIButton) {
        self.viewReportContainer.isHidden = true
        self.viewReportTxtView.isHidden = true
        self.reportTxtViewValue.resignFirstResponder()
    }
    
    @IBAction func btnReportAction(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            //to change font of title and message.
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 18.0)!]
            let titleAttrString = NSMutableAttributedString(string: "Report this artist", attributes: titleFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            let action1 = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.viewReportContainer.isHidden = false
                self.reportTxtViewValue.text = "WRITE_YOUR_REASON".localized()
                self.viewReportTxtView.isHidden = false
                self.reportTxtViewValue.resignFirstResponder()
            }

            let action2 = UIAlertAction(title: "No", style: .default) { (action) in
                self.viewReportContainer.isHidden = true
                self.viewReportTxtView.isHidden = true
                self.reportTxtViewValue.resignFirstResponder()
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            alertController.view.tintColor = UIColor.black
            alertController.view.backgroundColor = UIColor.black
            alertController.view.layer.cornerRadius = 40
            present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func cloaseOnPress(_ sender: UIButton) {
        self.imageSliderCollectionContainer.isHidden = true
    }
    
    
    @objc func imageTappedtap12(_ sender: UITapGestureRecognizer? = nil) {
        let Username =  self.lblInstagramSubscribers.text ?? "" // Your Instagram Username here
        let appURL = URL(string: "instagram://user?username=\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://instagram.com/\(Username)")!
            application.open(webURL)
        }
    }
    
    @objc func imageTappedtap13(_ sender: UITapGestureRecognizer? = nil) {
        let YoutubeID =  lblYoutubeSubscribers.text ?? "" // Your Youtube ID here
        let appURL = NSURL(string: "youtube://www.youtube.com/channel/\(YoutubeID)")!
        let webURL = NSURL(string: "https://www.youtube.com/channel/\(YoutubeID)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
    
    
    @objc func handletapviewAboutUs(_ sender: UITapGestureRecognizer? = nil) {
        
        isSliderShow = false
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = CATransitionType(rawValue: "flip")
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        imgViewUserPreview.layer.add(transition, forKey: kCATransition)
        viewContainerPreview.isHidden = false
        imgViewUserPreview.isHidden = false
        viewImageViewContainer.isHidden = false
        btnCrossImage.isHidden = false
        crossBack.isHidden = false
        imgViewUserPreview.image = imgProfile.image
    }
    
    @IBAction func btnPlayVideoAction(_ sender: UIButton) {
        if youtubeID == "" || youtubeID.isEmpty == true{
            if  let url = URL(string: localVideoUrl) {
                playVideo(url: url)
            }
        }else{
            //        playerView.load(withVideoId: youtubeID)
            //        print(c)
        }
    }
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    //MARK: Youtuve Viedo URL ID get and convert thumnail banner
    func extractYoutubeId(fromLink link: String) -> String {
        let regexString: String = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regExp = try? NSRegularExpression(pattern: regexString, options: .caseInsensitive)
        let array: [Any] = (regExp?.matches(in: link, options: [], range: NSRange(location: 0, length: (link.count))))!
        if array.count > 0 {
            let result: NSTextCheckingResult? = array.first as? NSTextCheckingResult
            youtubeID = (link as NSString).substring(with: (result?.range)!)
            print(youtubeID)
            if youtubeID == "" || youtubeID.isEmpty == true{
                self.playerView.isHidden = false
                self.youTubePlayer.isHidden = true
            }else{
                youtubeImageUrl = "https://img.youtube.com/vi/\(youtubeID)/0.jpg"
                //MARK: Image banner
                youTubePlayer.load(withVideoId: youtubeID)
                let urlImg = URL(string: youtubeImageUrl)
                imgViedoPlay.sd_setImage(with: urlImg)
                self.playerView.isHidden = true
                self.youTubePlayer.isHidden = false
                imgPlayBtnVideo.isHidden = true
                return youtubeID
            }
        }else{
            let url = URL(string: Api.videoUrl + link)!
            self.localVideoUrl = Api.videoUrl + link
            let urlSting : String = "\(Api.videoUrlThumbnail)\(self.getArtistProfile?.shows_video_thumbnail ?? "")"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            let urlImage = URL(string: urlStringaa)!
            self.imgViedoPlay.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgViedoPlay.sd_setImage(with: urlImage, placeholderImage: UIImage(named: ""))
            self.playerView.isHidden = false
            let when = DispatchTime.now() + 5
            DispatchQueue.main.asyncAfter(deadline: when){
                self.imgPlayBtnVideo.isHidden = false
            }
            self.youTubePlayer.isHidden = true
        }
        return ""
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    @IBAction func btnReviewonPress(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "BookingDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        controller.artistID = userArtistID
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnUpdateProfileOnPress(_ sender: UIButton) {
        
    }
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.back()
    }
    
    
    @IBAction func btnYoutubeLinkAction(_ sender: UIButton) {
        let YoutubeID =  "Ktync4j_nmA" // Your Youtube ID here
        let appURL = NSURL(string: "youtube://www.youtube.com/watch?v=\(YoutubeID)")!
        let webURL = NSURL(string: "https://www.youtube.com/watch?v=\(YoutubeID)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
        
    }
    
    
    
    @IBAction func btnInstagramAction(_ sender: UIButton) {
        let instagramHooks = "https://www.instagram.com/abhishekmishra3676/"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    
    
    
    @IBAction func btnChatAction(_ sender: UIButton) {
        userArtistID =  getArtistProfile?.id ?? 0
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FriendMsgVC") as! FriendMsgVC
        controller.name = getArtistProfile?.name ?? ""
        controller.userImage = getArtistProfile?.image ?? ""
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageController.currentPage = Int(pageIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    
   
    func reportArtist(artistID:Int,reason:String)  {
        let param = ["artist_id":artistID,"description":reason] as [String : Any]
        
        
        
        
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerReport, method: .post, param: param, header: headerToken) { (response, error) in
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    print("the response is \(response)")
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            Helper.showOKAlert(onVC: self, title: "Success", message: "Reported Successfully")
                            
                            let when = DispatchTime.now() + 3
                            DispatchQueue.main.asyncAfter(deadline: when){
                              // your code with delay
                                self.back()
                            }
                            
                        }
                        else{
                        }
                    }
                    else {
                        if let error_message = response["error"] as? String {
                            Helper.showOKAlert(onVC: self, title: "Error", message: error_message)
//                            self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error_message)
                        }
                    }
                }
                else {
//                    self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            Helper.showOKAlert(onVC: self, title: "nternet Error", message: "Please Check your Internet Connection")
        }
}
    
    
    @IBAction func btnReportSubmitAction(_ sender: UIButton) {
        
       
        
    }
    
    @IBAction func btnBookAction(_ sender: UIButton) {
        
        userArtistID =  getArtistProfile?.id ?? 0
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.SeleteDate)
    }
    
    func profileData(profile :GetArtistModel?)  {
        let imageUrl = Api.imageURLArtist
        self.lblName.text = profile?.name ?? ""
        
        self.lblBookingPrice.text = "BOOKING_PRICE".localized()
        self.lblGallery.text = "GALLERY".localized()
        self.lblInPersonData.text = "IN_PRESON".localized()
        self.lblVirtual.text = "VIRTUAL_SHOW".localized()
        self.lblSocialMedia.text = "SOCIAL_MEDIA_HANDLES".localized()
        btnBack.setTitle("back".localized(), for: .normal)
        self.lblAbout.text = "ABOUT".localized()
        self.lblChatAboutBooking.text = "HAVE_A_CHAT_BOOKING".localized()
        self.lblInstaLink.text = "INSTRAGRAM_ACCOUNT".localized()
        self.lblYoutubeAccount.text = "YOUTUBE_ACCOUNT".localized()
        self.viewProfile.text = "VIEW_PROFILE".localized()
        self.viewProfile12.text = "VIEW_PROFILE".localized()

        let myDouble = Double(profile?.converted_live_price ?? "") ?? 0.0
        let y1 = (myDouble*100).rounded()/100
        
       self.lblLiveShowPrice.text = "\(profile?.converted_currency ?? "")\(" ")\( y1)"
        if profile?.ratingValue == 0{
            btnSeeReview.isHidden = true
            btnSeeReview.isUserInteractionEnabled = false
            self.viewCosmoRating.isHidden = true
            self.lblNewBrandArtist.isHidden = false
            self.lblNewBrandArtist.text = "NEW_ARTIST".localized()
        }else{
            self.viewCosmoRating.isHidden = false
            self.lblNewBrandArtist.isHidden = true
            self.viewCosmoRating.rating = Double("\(profile?.ratingValue ?? 0)") ?? 0.0
            btnSeeReview.isHidden = false
            btnSeeReview.setTitle("SEE_REVIEW".localized(), for: .normal)

            btnSeeReview.isUserInteractionEnabled = true
        }
        if   whicShowTypeDigital == false{
            viewLivePriceValue.isHidden = true
            lblInPersonData.isHidden = true
            self.liveShowHeightConstant.constant = 30
            self.imgShowType.isHidden = true
            self.viewLiveShow.isHidden = false
            self.imgVirtualShowType.image = UIImage.init(named: "virtual")
//            self.imgShowType.image = UIImage.init(named: "virtual")
        }else{
            viewLivePriceValue.isHidden = false
             lblInPersonData.isHidden = false
            self.digitalShowHeightConstant.constant = 0
            self.viewDigitalShow.isHidden = true
            self.imgShowType.isHidden = false
            self.imgShowType.image = UIImage.init(named: "inperson")
        }
        
        let myDouble1 = Double(profile?.converted_digital_price ?? "") ?? 0.0
        let y = (myDouble1*100).rounded()/100
        print(y)
        
        self.lblDigitalShowPrice.text = "\(profile?.converted_currency ?? "")\(" ")\( y)"
        var urlSting : String = "\(Api.imageURLArtist)\(profile?.image ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        let urlImage = URL(string: urlStringaa)!
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        if profile?.image == ""{
            self.imgProfile.isUserInteractionEnabled = false
        }else{
            self.imgProfile.isUserInteractionEnabled = true
        }
        
        
        let attributedString = NSMutableAttributedString(string: profile?.descriptionValue ?? "")
        txtViewAbout.linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.blue] as [NSAttributedString.Key: Any]?
        txtViewAbout.attributedText = attributedString
        viewInstaGramProfile.isUserInteractionEnabled = false
        viewInstaGramProfile.isHidden = true
        self.viewYoutubeProfile.isUserInteractionEnabled = false
        viewYoutubeProfile.isHidden = true
        
        if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 == "" && getArtistProfile?.shows_image_3 == "" && getArtistProfile?.shows_image_4 == ""{
            
            imageArrayValue.append(getArtistProfile?.shows_image_1 ?? "")
            
        }else  if getArtistProfile?.shows_image_1 == "" && getArtistProfile?.shows_image_2 == "" && getArtistProfile?.shows_image_3 == "" && getArtistProfile?.shows_image_4 != ""{
            imageArrayValue.append(getArtistProfile?.shows_image_4 ?? "")
            
        }else  if getArtistProfile?.shows_image_1 == "" && getArtistProfile?.shows_image_2 != "" && getArtistProfile?.shows_image_3 == "" && getArtistProfile?.shows_image_4 == ""{
            imageArrayValue.append(getArtistProfile?.shows_image_2 ?? "")
            
        }else  if getArtistProfile?.shows_image_1 == "" && getArtistProfile?.shows_image_2 == "" && getArtistProfile?.shows_image_3 != "" && getArtistProfile?.shows_image_4 != ""{
            imageArrayValue.append(getArtistProfile?.shows_image_3 ?? "")
            
        }
        else if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 != "" && getArtistProfile?.shows_image_3 == "" && getArtistProfile?.shows_image_4 == ""{
            imageArrayValue.append(getArtistProfile?.shows_image_1 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_2 ?? "")
            
        }else if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 != "" && getArtistProfile?.shows_image_3 != "" && getArtistProfile?.shows_image_4 == ""{
            imageArrayValue.append(getArtistProfile?.shows_image_1 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_2 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_3 ?? "")
            
        }else  if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 != "" && getArtistProfile?.shows_image_3 != "" && getArtistProfile?.shows_image_4 != ""{
            imageArrayValue.append(getArtistProfile?.shows_image_1 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_2 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_3 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_4 ?? "")
            
        }else  if getArtistProfile?.shows_image_1 == "" && getArtistProfile?.shows_image_2 != "" && getArtistProfile?.shows_image_3 != "" && getArtistProfile?.shows_image_4 == ""{
            imageArrayValue.append(getArtistProfile?.shows_image_2 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_3 ?? "")
        }else  if getArtistProfile?.shows_image_1 == "" && getArtistProfile?.shows_image_2 != "" && getArtistProfile?.shows_image_3 == "" && getArtistProfile?.shows_image_4 != ""{
            imageArrayValue.append(getArtistProfile?.shows_image_2 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_4 ?? "")
        }else  if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 == "" && getArtistProfile?.shows_image_3 == "" && getArtistProfile?.shows_image_4 != ""{
            imageArrayValue.append(getArtistProfile?.shows_image_1 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_4 ?? "")
        }else  if getArtistProfile?.shows_image_1 != "" && getArtistProfile?.shows_image_2 == "" && getArtistProfile?.shows_image_3 != "" && getArtistProfile?.shows_image_4 == ""{
            imageArrayValue.append(getArtistProfile?.shows_image_1 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_3 ?? "")
        }else  if getArtistProfile?.shows_image_1 == "" && getArtistProfile?.shows_image_2 == "" && getArtistProfile?.shows_image_3 != "" && getArtistProfile?.shows_image_4 != ""{
            imageArrayValue.append(getArtistProfile?.shows_image_4 ?? "")
            imageArrayValue.append(getArtistProfile?.shows_image_3 ?? "")
        }
        
        
        
        print("the number of gallery images is \(imageArrayValue.count)")
        print("the number of gallery images is \(imageArrayValue)")

        
        if  profile?.social_link_insta ?? "" != "" &&  profile?.social_link_youtube ?? "" != ""{
            viewInstaGramProfile.isUserInteractionEnabled = true
            viewInstaGramProfile.isHidden = false
            self.viewYoutubeProfile.isUserInteractionEnabled = true
            viewYoutubeProfile.isHidden = false
            viewContainerSocialLoginView.isHidden = false
            viewSocilaLoginContainerHeight.constant = 138
            
        }
        else if profile?.social_link_insta ?? "" == "" &&   profile?.social_link_youtube ?? "" != ""{
            
            viewInstaGramProfile.isUserInteractionEnabled = false
            viewInstaGramProfile.isHidden = true
            self.viewYoutubeProfile.isUserInteractionEnabled = true
            viewYoutubeProfile.isHidden = false
            viewContainerSocialLoginView.isHidden = false
            viewSocilaLoginContainerHeight.constant = 138
        }else if profile?.social_link_insta ?? "" != "" &&   profile?.social_link_youtube ?? "" == ""{
            viewInstaGramProfile.isUserInteractionEnabled = true
            viewInstaGramProfile.isHidden = false
            self.viewYoutubeProfile.isUserInteractionEnabled = false
            viewYoutubeProfile.isHidden = true
            viewContainerSocialLoginView.isHidden = false
            viewSocilaLoginContainerHeight.constant = 138
        }else if  profile?.social_link_insta ?? "" == "" &&    profile?.social_link_youtube ?? "" == ""{
            viewInstaGramProfile.isUserInteractionEnabled = false
            viewInstaGramProfile.isHidden = true
            self.viewYoutubeProfile.isUserInteractionEnabled = false
            viewYoutubeProfile.isHidden = true
            viewContainerSocialLoginView.isHidden = true
            viewSocilaLoginContainerHeight.constant = 0
            
        }
        else{
            viewInstaGramProfile.isUserInteractionEnabled = false
            viewInstaGramProfile.isHidden = true
            self.viewYoutubeProfile.isUserInteractionEnabled = false
            viewYoutubeProfile.isHidden = true
        }
        self.imageSliderCollection.reloadData()
        self.lblInstagramSubscribers.text = profile?.social_link_insta ?? ""
        self.lblYoutubeSubscribers.text = profile?.social_link_youtube ?? ""
        
        self.VideoLink = profile?.shows_video ?? ""
        print(VideoLink)
        
        if profile?.shows_video ?? "" == "" {
            imgViedoPlay.isHidden = true
            novideoLbl.isHidden = false
            novideoLbl.text = "NO_VIDEO_UPLOADED".localized()
            playerView.isUserInteractionEnabled = false
            imgPlayBtnVideo.isHidden = true
            
        }else{
            imgViedoPlay.isHidden = false
            novideoLbl.isHidden = true
            playerView.isUserInteractionEnabled = true
            self.extractYoutubeId(fromLink: VideoLink)
            imgPlayBtnVideo.isHidden = false
        }
        self.serviceCollectionView.reloadData()
        if profile?.shows_image_1 == "" && profile?.shows_image_2 == "" && profile?.shows_image_3 == "" && profile?.shows_image_4 == ""{
            heightConstant.constant = 0
            self.showCollectionView.isHidden = true
            self.dashlineView.isHidden = true
            self.lblGallery.isHidden = true
        }else{
            heightConstant.constant = 111
            self.showCollectionView.isHidden = false
            self.dashlineView.isHidden = false
            self.lblGallery.isHidden = false
            self.showCollectionView.reloadData()
        }
    }
}

extension ViewProfileVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}


extension ViewProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.showCollectionView {
            
            return imageArrayValue.count
            
        }else if collectionView == self.imageSliderCollection {
            self.pageController.numberOfPages = self.imageArrayValue.count
            return self.imageArrayValue.count
        }else{
            if self.getArtistProfile?.categoryArtist.count ?? 0 != 0{
                return self.getArtistProfile?.categoryArtist.count ?? 0
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.serviceCollectionView {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCollectionViewCell", for: indexPath) as! serviceCollectionViewCell
            cell1.lblService.text = "\( getArtistProfile?.categoryArtist[indexPath.row].category_name ?? "")"
            return cell1
            
        }else if collectionView == self.imageSliderCollection {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "imageSLiderCell", for: indexPath) as! imageSLiderCell
            cell1.imageWIdth.constant = self.view.frame.size.width
            cell1.imageHeight.constant = self.view.frame.size.height
            let indexData = self.imageArrayValue[indexPath.row]
            let urlSting : String = "\(Api.imageURLArtist)\(indexData)"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            let urlImage = URL(string: urlStringaa)!
            cell1.image.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell1.image.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            return cell1
        }else {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "showCollectionViewCell", for: indexPath) as! showCollectionViewCell
             let urlSting : String = "\(Api.imageURLArtist)\(imageArrayValue[indexPath.row])"
                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                let urlImage = URL(string: urlStringaa)!
                cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                
//            }else if indexPath.row == 1{
//                let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_2 ?? "")"
//                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
//                let urlImage = URL(string: urlStringaa)!
//                cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
//
//            }else if indexPath.row == 2{
//                let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_3 ?? "")"
//                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
//                let urlImage = URL(string: urlStringaa)!
//                cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
//
//            }else{
//                let urlSting : String = "\(Api.imageURLArtist)\(getArtistProfile?.shows_image_4 ?? "")"
//                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
//                let urlImage = URL(string: urlStringaa)!
//                cell2.imgShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                cell2.imgShow.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
//            }
            
            return cell2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.showCollectionView{
            self.imageSliderCollectionContainer.isHidden = false
            let rectValue = self.imageSliderCollection.layoutAttributesForItem(at: IndexPath(row: indexPath.item, section: 0))?.frame
            self.imageSliderCollection.scrollRectToVisible(rectValue!, animated: false)
        }
    }
}

extension UIView {
    func viewLiveShowDashline() {
        let color = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00).cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [2,2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}


extension ViewProfileVC : GetArtistProfileViewModelProtocol{
    func successAlert(susccessTitle: String, successMessage: GetArtistModel?, from: Bool) {
        if from == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "something went wrong!", btnOkTitle: "Done") {
            }
        }else{
            getArtistProfile = successMessage
            self.profileData(profile: successMessage)
        }
    }
    
    func addAddress() {
    }
    
    
}

extension ViewProfileVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "WRITE_YOUR_REASON".localized(){
            textView.text = ""
        }}
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "WRITE_YOUR_REASON".localized()
        } }
}
