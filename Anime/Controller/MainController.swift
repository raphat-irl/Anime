//
//  MainController.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 7/11/2565 BE.
//
import Foundation
import UIKit
import FirebaseAuth
import Firebase

class MainController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UISearchControllerDelegate, UISearchBarDelegate{

    @IBOutlet weak var moviesView: UITableView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    
//    var searchText:String = ""
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var menuList = [Menu]()
    var filterList = [Menu]()
    var searchFilterList = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestData(searchText: "")

        if FirebaseAuth.Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinatiionVC = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController {
                self.navigationController?.pushViewController(destinatiionVC, animated: true)
            }
        }
    }
    
    func setupView(){
        favButton.addTarget(self, action: #selector(favMoviesBtnTapped), for: .touchUpInside)
        
        searchButton.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        
        logoutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        
        moviesView.register(UINib(nibName: MainCell.identifier, bundle: nil),forCellReuseIdentifier: MainCell.identifier)
        
        searchController.searchBar.delegate = self
        
        let searchData = UDM.shared.defaults?.value(forKey: "SavedSearchDataArry") as? String
        
        searchController.searchBar.text = searchData
        searchController.becomeFirstResponder()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Anime Name"
        
        navigationItem.searchController = searchController
    
        definesPresentationContext = true
    }
    
    @IBAction func favMoviesBtnTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destivationVC = storyboard.instantiateViewController(withIdentifier: "FavoriteController") as? FavoriteController {
            
            self.navigationController?.pushViewController(destivationVC, animated: true)
        }
    }
    
    //  MARK: - UITableView datasouce & delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.identifier, for: indexPath as IndexPath) as? MainCell else{
            return UITableViewCell()
        }
        let data = menuList[indexPath.row]
        cell.setCell(menu: data)
        cell.setFavBtn()
        cell.favstarButton.addTarget(self
            , action: #selector(self.onSaveBtnTapped)
            , for: .touchUpInside)
        cell.favstarButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = menuList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "DetailController") as? DetailController{
            destinationVC.menu = data
            destinationVC.delegate = self
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    //MARK: - logOutTapped()
    
    @objc private func logOutTapped(){
        
        do{
            try FirebaseAuth.Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destivationVC = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController {
                
                self.navigationController?.pushViewController(destivationVC, animated: true)
            }
            print("sigh out")
        } catch {
            print("an error occurred")
        }
    }
    
    //  MARK: - searchBtnTapped()
    
    @objc private func searchBtnTapped(){
        let alert = UIAlertController(title: "Anime Name", message: "", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Anime Name"
            field.returnKeyType = .continue
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { [self] _
            //  Read textfied values
    
            in
            
            guard let field = alert.textFields else{
                return
            }
            
            let searchField = field[0]
//            searchText = searchField.text ?? ""
            guard let search = searchField.text?.trim(), !search.isEmpty else{
                
                let emptyfield = UIAlertController(title: "⚠️", message: "Please insert your anime name", preferredStyle: .alert)
                
                emptyfield.addAction(UIAlertAction(title: "OK", style: .cancel,handler: nil))
                
                present(emptyfield, animated: true)
                
                return
            }
            requestData(searchText: searchField.text ?? "")
            moviesView.reloadData()
        }))
        present(alert, animated: true)
    }
    
    @objc func onSaveBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let position = sender.tag
        let data = menuList[position]
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "starlight.png"),for: UIControl.State.selected)
            
            let appPreference = AppPreference()
            
            let email = appPreference.getValueString(AppPreference.email)
            
            guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else{
                return }
            
            let userFavData = ["uid": uid,"mal_id": data.mal_id, "img": data.image_url, "synopip":data.decs, "title": data.title] as [String : Any]
            
            Firestore.firestore().collection(email).document(data.title).setData(userFavData) {
                err in
                if let err = err {
                    print(err)
                    
                    return
                }
                print("Success save user favorite movies")
                
                self.moviesView.reloadData()
            }
        
        } else {
            sender.setImage(UIImage(named: "star.png"),for:UIControl.State.normal)
            
            let appPreference = AppPreference()
            let email = appPreference.getValueString(AppPreference.email)
            
            Firestore.firestore().collection(email).document(data.title).delete(){ err in
                
                if let err = err {
                    
                    print("Error removing document: \(err)")
                    
                } else {
                     
                    print("Document successfully removed!")
                    
                    self.moviesView.reloadData()
                }
            }
        }
    }

    //  MARK: - Request api
    
    func requestData(searchText:String) {
        let baseUrl = "https://api.jikan.moe/v4/anime?q=\(searchText.percentEncoding())"
        let connection = Connection(url: baseUrl)
        connection.requestMethod = "GET"
        connection.onComplete({ (result) -> Void in
            let resultData = result.data(using: String.Encoding.utf8)
            let json = JSON(data: resultData!, options: JSONSerialization.ReadingOptions(rawValue: 0), error: nil)
            let error = json["error"].int16Value
            if(error == 0) {
                
                self.searchFilterList.removeAll()
                self.filterList.removeAll()
                self.menuList.removeAll()
            
                let dataJarr = json["data"].arrayValue
                for i in 0..<dataJarr.count {
                    let resultJObj = dataJarr[i]
                    let mal_id = resultJObj["mal_id"].intValue
                    let title = resultJObj["title"].stringValue
                    let synopsis = resultJObj["synopsis"].stringValue
                    let web_url = resultJObj["url"].stringValue
                    let score = resultJObj["score"].floatValue
                    
                    var imagelist:String = ""
                    
                    let imagesObj = resultJObj["images"]
                   
                        let jpgObj = imagesObj["jpg"]
                        imagelist = jpgObj["image_url"].stringValue
                    
                    //  Create instance
                    let menu = Menu(mal_id: mal_id,
                                    title: title,
                                    score: score,
                                    decs: synopsis,
                                    web_url: web_url,
                                    image_url: imagelist,
                                    isSelected: false,
                                    isFav: false)
                    
                    //  Add to list
                    self.menuList.append(menu)
                    self.filterList.append(menu)
                    self.searchFilterList.append(menu)
                }
                
                //  Reload data
                self.moviesView.reloadData()
                self.stopLoading()
            }
        })
        connection.onLostConnection({ () -> Void in
        })
        connection.execute()
        self.startLoading()
    }
    
    //  MARK: - filterContentForSearchText
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            return
        }
        menuList = searchFilterList.filter{$0.title.lowercased().contains(searchText.lowercased())}

        moviesView.reloadData()
    }
    
    //  MARK: - UserDefaultManager
    
    class UDM {

        static let shared = UDM()

        let defaults = UserDefaults(suiteName: "com.test.Anime.saved.searchdata")
    }
}

extension MainController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
      
      //Set
      let appPreFerence = AppPreference()

      appPreFerence.setValueBoolean(AppPreference.firstTime, value: true)
      
      appPreFerence.synchronize()
      
      UDM.shared.defaults?.setValue(searchBar.text, forKey: "SavedSearchDataArry")
      
      UDM.shared.defaults?.synchronize()

  }
}

extension MainController: DetailDelegate {
    func printAnyString() {
        print("test")
    }
}




