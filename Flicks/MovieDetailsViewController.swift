//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Shaz Rajput on 7/17/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieScrollView: UIScrollView!
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var moviePosterBackdropImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePopularity: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    var moviePosterURL = ""
    var movieTitle = "DEFAULT TITLE"
    var releaseDate = ""
    var popularity = 0.0
    var overview = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieScrollView.contentSize = CGSize(width: movieScrollView.frame.size.width, height: movieInfoView.frame.origin.y + movieInfoView.frame.size.height)
        // Do any additional setup after loading the view.
        moviePosterBackdropImage.setImageWithURL(NSURL(string: moviePosterURL)!)
        movieTitleLabel.text = movieTitle
        let popularityNumber = String(format: "%.2f", popularity)
        moviePopularity.text = popularityNumber + "%"
        movieReleaseDate.text = releaseDate
        movieOverview.text = overview
        //movieOverview.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
