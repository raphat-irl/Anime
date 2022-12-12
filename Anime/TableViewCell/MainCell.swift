//
//  MainCell.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 7/11/2565 BE.
//
import Kingfisher
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MainCell: UITableViewCell {
    
    @IBOutlet weak var favstarButton:UIButton!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var animeImage:UIImageView!
    @IBOutlet weak var descLabel:UILabel!
    @IBOutlet weak var scoreLabel:UILabel!
    
    static let identifier = "MainCell"
    
    
    var userFavMoviesList: [UserFavMovies] = []
    var menuList = [Menu]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(menu:Menu){
        
        animeImage.kf.setImage(with: URL(string: menu.image_url))

        titleLabel.text = menu.title
        descLabel.text = menu.decs
        scoreLabel.text = String(menu.score)
        
    }
    func setFavBtn () {
//
//        let data = menuList
//
//        let appPreference = AppPreference()
//
//        let email = appPreference.getValueString(AppPreference.email)
//
//        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else{
//            return }
//
//        let favMoviesRef = Firestore.firestore().collection(email)
//
//        let query = favMoviesRef.whereField("mal_id", isNotEqualTo: 0)
        
        for favlist in userFavMoviesList {
            let mal_id_list = menuList.filter{
                id in
                return favlist.favmal_id == id.mal_id
            }
            if mal_id_list.count > 0 {
            favstarButton.setImage(UIImage(named: "starligh.png"), for: UIControl.State.selected)
            } else {
            favstarButton.setImage(UIImage(named: "star.png"),for: UIControl.State.normal)
            }
        }
    }
}
