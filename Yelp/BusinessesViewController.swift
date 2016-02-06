//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    var businesses: [Business]!
    var category: String!
    
    @IBOutlet weak var businessTableView: UITableView!
    
    var searchBar : UISearchBar!
    var searchResults : [Business]!
    
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var offset: Int? = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.delegate = self
        businessTableView.dataSource = self
        
        //set tableviewcell row height
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120
        
        businessTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
        //            self.businesses = businesses
        //
        //            self.searchResults = self.businesses
        //            self.businessTableView.reloadData()
        //
        ////            for business in self.searchResults {
        ////                print(business.name!)
        ////                print(business.address!)
        ////            }
        //        })
        
        //Example of Yelp search with more search options specified
        Business.searchWithTerm("\(category)", latitude: 37.721839, longitude: -122.476927, sort: .Distance, categories: [], deals: false, offset: nil, limit: 20) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.searchResults = self.businesses
            self.businessTableView.reloadData()
            
            for business in businesses {
                print(business.id!)
                print(business.name!)
                print(business.address!)
            }
        }
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        self.searchBar = UISearchBar()
        searchBar.delegate = self
        self.searchBar.sizeToFit()
        searchBar.placeholder = "Enter search term"
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = UIColor(red: 218/255, green: 56/255, blue: 40/255, alpha: 1)
        //        navigationController.navigationBar.translucent = NO;
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, businessTableView.contentSize.height, businessTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        businessTableView.addSubview(loadingMoreView!)
        
        var insets = businessTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        businessTableView.contentInset = insets
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchResults = self.businesses
        self.businessTableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = searchText.isEmpty ? businesses : businesses!.filter({ (business: Business) -> Bool in
            return (business.name)!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        businessTableView.reloadData()
    }
    
    
    //Implement TableView DataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = searchResults[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    
    func loadMoreData() {
        
        //Example of Yelp search with more search options specified
        Business.searchWithTerm("\(category)", latitude: 37.721839, longitude: -122.476927, sort: .Distance, categories: [], deals: false, offset: offset, limit:20) { (businesses: [Business]!, error: NSError!) -> Void in
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            if (businesses != []) {
                for business in businesses {
                    self.businesses.append(business)
                }
                self.searchResults = self.businesses
                self.businessTableView.reloadData()
                self.offset! = self.offset! + 20
            }
            
            // Update flag
            self.isMoreDataLoading = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = businessTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && businessTableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, businessTableView.contentSize.height, businessTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
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

class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.hidden = true
    }
    
    func startAnimating() {
        self.hidden = false
        self.activityIndicatorView.startAnimating()
    }
}
