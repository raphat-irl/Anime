//
//  FavoriteController.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 9/11/2565 BE.
//

// test tes t

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FavoriteController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var menuView:UICollectionView!
    @IBOutlet weak var noneItemImage:UIImageView!
    
    var userFavMoviesList: [UserFavMovies] = []
    
    var menuList: [Menu]!
    
    private var itemWidth: CGFloat = 0
    private var itemHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favUserData()
    }
    
    func setupView(){
        
        noneItemImage.isHidden = true
        
        menuView.register(UINib(nibName: FavoriteCell.identifier, bundle: nil), forCellWithReuseIdentifier: FavoriteCell.identifier)
        
        var screenWidth = UIScreen.main.bounds.width
        screenWidth -= 80
            
        itemWidth = screenWidth / CGFloat(2)
        itemHeight = 240
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userFavMoviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath as IndexPath) as? FavoriteCell else {
            return UICollectionViewCell()
            
        }
        
        let data = userFavMoviesList[indexPath.row]
        cell.setCell(list: data, positioin: indexPath.row, itemWidth: self.itemWidth)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = userFavMoviesList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "DetailController") as? DetailController {
            destinationVC.userFavMoviesList = data
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func favUserData() {
        
        self.startLoading()
        
        let appPreference = AppPreference()
        let email = appPreference.getValueString(AppPreference.email)
        
        guard (FirebaseAuth.Auth.auth().currentUser?.uid) != nil else{
            return }
        
        let userFavData = Firestore.firestore().collection(email).getDocuments() {
            (querySnapshot, err) in
            if let err = err{
                print("Error getting document: \(err)")
            } else {
                self.userFavMoviesList.removeAll()
                if querySnapshot?.documents.count == 0 {
                    self.menuView.isHidden = true
                    self.noneItemImage.isHidden = false
                } else {
                    self.menuView.isHidden = false
                    self.noneItemImage.isHidden = true
                }
                for userFavData in querySnapshot!.documents {
                    print ("getData \(userFavData.documentID) => \(userFavData.data())")
                    
                    let mal_id = userFavData["mal_id"] as? Int
                    let img = userFavData["img"] as? String
                    let title = userFavData["title"] as? String
                    let decs = userFavData["synopip"] as? String
                    let web_url = userFavData["web_url"] as? String
                    
                    let userFavAnimes = UserFavMovies(favmal_id: mal_id ?? 0 ,favTitle: title ?? "", favDecs: decs ?? "", favImage_url: img ?? "", favAnime_url: web_url ?? "")
                    
                    self.userFavMoviesList.append(userFavAnimes)
                    
                    }
                
                self.menuView.reloadData()
                self.stopLoading()
                }
            }
        }
    }
    
    

