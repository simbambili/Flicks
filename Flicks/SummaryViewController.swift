//
//  ViewController.swift
//  Flicks
//
//  Created by Shaz Rajput on 7/16/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let API_URL = "https://api.themoviedb.org/3/movie/now_playing"
    let IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w342"
    let CLIENT_ID = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var isMoreDataLoading = false
    var movieDataResults = [NSDictionary()]
    
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var summaryTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.networkErrorView.hidden = true
        self.summaryTableView.delegate = self
        self.summaryTableView.dataSource = self
        //self.summaryTableView.rowHeight = 140
        let contentWidth = summaryTableView.bounds.width
        let contentHeight = summaryTableView.bounds.height * 3
        summaryTableView.contentSize = CGSizeMake(contentWidth, contentHeight)
        self.setMovieDataResponse()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        summaryTableView.insertSubview(refreshControl, atIndex: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        let indexPath = summaryTableView.indexPathForCell(sender as! UITableViewCell)
        let movieDictionary = self.movieDataResults[indexPath!.row] as NSDictionary
        if let moviePosterURLSuffix = movieDictionary["poster_path"] as? String {
            movieDetailsViewController.moviePosterURL = "\(IMAGE_BASE_URL)\(moviePosterURLSuffix)"

        }
        if let movieTitle = movieDictionary["title"] as? String {
            movieDetailsViewController.movieTitle = movieTitle
        }
        if let movieOverview = movieDictionary["overview"] as? String {
            movieDetailsViewController.overview = movieOverview
        }
        if let moviePopularityPercent = movieDictionary["popularity"] as? Double {
            //NSLog("popularity: \(moviePopularityPercent)")
            movieDetailsViewController.popularity = moviePopularityPercent
        }
        if let movieReleaseDate = movieDictionary["release_date"] as? String {
            movieDetailsViewController.releaseDate = movieReleaseDate
        }
        
        
    }
    
    func setMovieDataResponse() {

        //NSLog("setMovieDataResponse method called")
        
        if (self.isConnectedToNetwork()){
            self.networkErrorView.hidden = true
            let url = NSURL(string:"\(API_URL)?api_key=\(CLIENT_ID)")
            let request = NSURLRequest(URL: url!)
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate:nil,
                delegateQueue:NSOperationQueue.mainQueue()
            )
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            
            let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                          completionHandler: { (dataOrNil, response, error) in
                                                                            if let data = dataOrNil {
                                                                                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                    data, options:[]) as? NSDictionary {
                                                                                    //NSLog("response: \(responseDictionary)")
                                                                                    
                                                                                    if let myResponse = responseDictionary["results"] as? [NSDictionary] {
                                                                                        //NSLog("response\n\n \(myResponse)")
                                                                                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                                                                                        self.movieDataResults = myResponse
                                                                                        self.summaryTableView.reloadData()
                                                                                        
                                                                                    }
                                                                                }
                                                                                
                                                                            }
            });
            task.resume()

        } else {
            self.networkErrorView.hidden = false
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = summaryTableView.dequeueReusableCellWithIdentifier("com.walmartlabs.shaz.flicks.movieprototypecell", forIndexPath: indexPath) as! MovieTableViewPrototypeCell
        let movieDictionary = self.movieDataResults[indexPath.row] as NSDictionary
        if let movieTitle = movieDictionary["title"] as? String {
            cell.movieTitleLabel.text = movieTitle
        }
        if let movieOverview = movieDictionary["overview"] as? String {
            cell.movieSummaryLabel.text = movieOverview
            cell.movieSummaryLabel.sizeToFit()
        }
        if let moviePosterURLSuffix = movieDictionary["poster_path"] as? String {
            let moviePosterURL = IMAGE_BASE_URL + moviePosterURLSuffix
            //NSLog("movie poster URL: \(moviePosterURL)")
            cell.movieImageView.setImageWithURL(NSURL(string: moviePosterURL)!)
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieDataResults.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.summaryTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.summaryTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        if (self.isConnectedToNetwork()){
            self.networkErrorView.hidden = true

            //NSLog("Refresh method called")
            let url = NSURL(string:"\(API_URL)?api_key=\(CLIENT_ID)")
            let request = NSURLRequest(URL: url!)
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate:nil,
                delegateQueue:NSOperationQueue.mainQueue()
            )
        
            let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                          completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    self.networkErrorView.hidden = true
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //NSLog("response: \(responseDictionary)")
                            if let myResponse = responseDictionary["results"] as? [NSDictionary] {
                                //NSLog("response\n\n \(myResponse)")
                                self.movieDataResults = myResponse
                                self.summaryTableView.reloadData()
                                refreshControl.endRefreshing()
                            }
                    }
                    
                }
            });
            task.resume()
        } else {
            self.networkErrorView.hidden = false
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

}

