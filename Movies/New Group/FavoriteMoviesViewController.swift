//
//  FavoriteMoviesViewController.swift
//  Movies
//
//  Created by Mujahed Ansari on 20/11/21.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var moviesArray = [R_Movies]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesArray =  DBManager.getMoviesList()
        // Do any additional setup after loading the view.
    }

    @objc func unLikeButtonpTapped(sender: UIButton) {
        let tempMovie = moviesArray[sender.tag]
        DBManager.CRUDOperations(.delete, object: tempMovie)
        moviesArray =  DBManager.getMoviesList()
        tableView.reloadData()
    }//end function body.
    
}

extension FavoriteMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTVCell") as! MovieTVCell
        let tempMovieInfo = moviesArray[indexPath.row]
        cell.iconImageView!.sd_setImage(with: URL(string: (tempMovieInfo.movie_icon) ), placeholderImage: UIImage(named: ""))
        cell.title_lbl.text = tempMovieInfo.name
        cell.discription_lbl.text = tempMovieInfo.m_descripton
        cell.rating_lbl.text = tempMovieInfo.ratings
        cell.likeButtton.setImage(UIImage(named: "delete"), for: .normal)
        cell.likeButtton.tag = indexPath.row
        cell.likeButtton.addTarget(self, action: #selector(unLikeButtonpTapped), for: .touchDown)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 140
    }//end function body.
    
}
