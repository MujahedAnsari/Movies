//
//  ViewController.swift
//  Movies
//
//  Created by Mujahed Ansari on 19/11/21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var moviesCategory = [MoviesDataResponse]()
    var OpenSectionNumber = -1
    var isSearching = false
    var searchmovie_list = [MoviesResponse]()
    var moviesArray = [MoviesResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            MoviesListingAPI.init(_httpUtility: HttpUtility()).callAPI { moviesList in
                print(moviesList)
                if let tempMoviesList = moviesList {
                    self.moviesCategory = tempMoviesList
                    self.getAllMoviesIntoArray()
                    DispatchQueue.main.async {
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    }
                }
            }
        }else{
            print("Internet Connection not Available!")
            CustomAlert.shared.alert(title: "No Internet Connnection", message: "Internet Connection not Available!", controller: self)
        }
    }//end viewDidLoad function body.
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        
    }//end function body.
    
    private func getAllMoviesIntoArray() {
        for mcategory in  moviesCategory {
            if let mlist =  mcategory.movie_list {
                for tempMovie in mlist {
                    moviesArray.append(tempMovie)
                }
            }//end if let block.
        }//end outer forloop
    }//end function body.
    
    private func searchMoviesList(searchText: String) {
        searchmovie_list =  moviesArray.filter { tempMovies in
            return tempMovies.name?.contains(searchText) ?? false
        }
    }//end function body.
    
    @objc func likeButtonTapped(sender: UIButton){
       let tempMovie = moviesArray[sender.tag]
       let tempRmovie = DBModelConverter.shared.convertor(movies: tempMovie)
        if let tempName = tempMovie.name, DBManager.isAvailableIntoDB(movieName: tempName){
            DBManager.CRUDOperations(.update, object: tempRmovie)
       }else {
           DBManager.CRUDOperations(.insert, object: tempRmovie)
       }
        tableView.reloadData()
    }//end function body.
    
    private func getMoviesCell(indexPath: IndexPath)-> MovieTVCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTVCell") as! MovieTVCell
        var tempMovieInfo: MoviesResponse
        if isSearching {
            tempMovieInfo = searchmovie_list[indexPath.row]
        }else {
            tempMovieInfo = (moviesCategory[indexPath.section].movie_list?[indexPath.row - 1])!
        }
        cell.iconImageView!.sd_setImage(with: URL(string: (tempMovieInfo.movie_icon ?? "") ), placeholderImage: UIImage(named: ""))
        cell.title_lbl.text = tempMovieInfo.name
        cell.discription_lbl.text = tempMovieInfo.description
        cell.rating_lbl.text = tempMovieInfo.ratings
         if let tempName = tempMovieInfo.name, DBManager.isAvailableIntoDB(movieName: tempName){
            cell.likeButtton.setImage(UIImage(named: "favorite"), for: .normal)
        }else {
            cell.likeButtton.setImage(UIImage(named: "unfavorite"), for: .normal)
        }
        if isSearching {
            cell.likeButtton.tag = indexPath.row
        }else {
            cell.likeButtton.tag = indexPath.row - 1
        }
        cell.likeButtton.addTarget(self, action: #selector(likeButtonTapped), for: .touchDown)
        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        }else {
            return moviesCategory.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchmovie_list.count
        }else {
            if section == OpenSectionNumber {
                return  (moviesCategory[section].movie_list?.count ?? 0) + 1
            }else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            return getMoviesCell(indexPath: indexPath)
        }else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCategoryTVCell") as! MovieCategoryTVCell
                if OpenSectionNumber == indexPath.section {
                    cell.arrowImageView?.image = UIImage(named: "upArrow")
                }else {
                    cell.arrowImageView?.image = UIImage(named: "downArrow")
                }
                cell.title_lbl.text = moviesCategory[indexPath.section].movie_category
                return cell
            }else {
                return getMoviesCell(indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching {
            return 140
        }else if indexPath.row == 0 {
            return 40
        }else {
            return 140
        }
    }//end function body.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if OpenSectionNumber == indexPath.section {
                OpenSectionNumber = -1
            }else {
                OpenSectionNumber = indexPath.section
            }
            tableView.reloadData()
        }else {
            
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            isSearching = false
            searchBar.resignFirstResponder()
        }else {
            isSearching = true
        }
        searchMoviesList(searchText: searchText)
        tableView.reloadData()
        print(searchText)
    }
}

