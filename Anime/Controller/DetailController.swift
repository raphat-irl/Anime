//
//  DetailController.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 8/11/2565 BE.
//

//test tes t

import UIKit
import Firebase
import FirebaseAuth

protocol DetailDelegate: AnyObject {
    func printAnyString()
}

class DetailController: UIViewController {
    
    @IBOutlet weak var animeDetailLabel:UILabel!
    @IBOutlet weak var animeDetailImage:UIImageView!
    @IBOutlet weak var descDetailLabel:UILabel!
    @IBOutlet weak var addfavDetailButton:UIButton!
    @IBOutlet weak var unfavDetailButton:UIButton!
    @IBOutlet weak var webDetailButton:UIButton!
    
    var menu:Menu!
    
    var delegate: DetailDelegate?
    
    var userFavMoviesList: UserFavMovies!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let delegate = delegate else {
              return
            }
            delegate.printAnyString()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupView(){
        
        addfavDetailButton.layer.borderWidth = 1
        addfavDetailButton.layer.cornerRadius = 8
        addfavDetailButton.layer.borderColor = UIColor.gray.cgColor
        
        unfavDetailButton.layer.borderWidth = 1
        unfavDetailButton.layer.cornerRadius = 8
        unfavDetailButton.layer.borderColor = UIColor.gray.cgColor
        
        webDetailButton.layer.borderWidth = 1
        webDetailButton.layer.cornerRadius = 8
        webDetailButton.layer.borderColor = UIColor.gray.cgColor
        
        if menu != nil {
            animeDetailImage.kf.setImage(with: URL(string: menu.image_url))
            
            animeDetailLabel.text = menu.title
            descDetailLabel.text = menu.decs
            
        }
        
        if userFavMoviesList != nil {
            
            animeDetailImage.kf.setImage(with: URL(string: userFavMoviesList.favImage_url))
            
            animeDetailLabel.text = userFavMoviesList.favTitle
            descDetailLabel.text = userFavMoviesList.favDecs
        }
    }
    //cant open from fav controller
    @IBAction func onOpenWebBtnTapped(_ sender: UIButton){
        
        if menu != nil {
            if let url = URL(string: menu.web_url), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        if userFavMoviesList != nil {
            if let url = URL(string: userFavMoviesList.favAnime_url), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }

    }
    
    @IBAction func onAddFavBtnTapped(_ sender: UIButton) {

        let appPreference = AppPreference()
        let email = appPreference.getValueString(AppPreference.email)
        
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {
            return }
    
        let userFavData = ["mal_id": menu.mal_id,"uid": uid,"img": menu.image_url,"synopip": menu.decs,"title":menu.title,"web_url": menu.web_url] as [String : Any]
        
        Firestore.firestore().collection(email).document(menu.title).setData(userFavData) {
            err in
            if let err = err {
                print(err)
                
                return
            }
            print("Success save user favorite movies")
        }
        
        addfavDetailButton.isHidden = true
        unfavDetailButton.isHidden = false
        
        }
    
    @IBAction func onUnFavBtnTapped(_ sender:UIButton){
        
        let appPreference = AppPreference()
        let email = appPreference.getValueString(AppPreference.email)
        //cant Delete from fav controller
        
        if menu != nil {
            Firestore.firestore().collection(email).document(menu.title).delete() {
                err in
        
                if let err = err {
                    
                    print("Error to removing document: \(err)")
                    
                } else {
                    
                    print("Document successfully removed")
                    
                    self.unfavDetailButton.isHidden = true
                    self.addfavDetailButton.isHidden = false
                }
            }
        }
        
        if userFavMoviesList != nil {
            Firestore.firestore().collection(email).document(userFavMoviesList.favTitle).delete() {
                err in
        
                if let err = err {
                    
                    print("Error to removing document: \(err)")
                    
                } else {
                    
                    print("Document successfully removed")
                    
                    self.unfavDetailButton.isHidden = true
                    self.addfavDetailButton.isHidden = false
                }
            }
        }
    }
}
    


