//
//  SearchViewController.swift
//  Yelp
//
//  Created by Monte's Pro 13" on 2/4/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
 //   var categories : [Category]!
    
    var categories :[String]! = ["Restaurants", "Bars", "Coffee & Tea", "More Categories"]
    var categoryImages :[String]! = ["restaurant", "bar", "coffeeTea", "more"]

    @IBOutlet weak var categoryTableView: UITableView!
    
    var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
      //  initCategories()
        
        categoryTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        categoryTableView.reloadData()
        
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
//        self.searchResults = self.businesses
//        self.businessTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
            //categories?.count ?? 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! SearchCell
        cell.categoryNameLabel.text = categories[indexPath.row]
        cell.categoryImageView.image = UIImage(named: "\(categoryImages[indexPath.row])")
      //  print("\(categoryImages[indexPath.row])")
        
//        cell.category = ["Restaurants", "ImageName"] as! Category
//          //  categories[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
//    func initCategories() {
//        
//         = ["name":"Restaurants", "image":"ImageName"]
//        
//        categories = [category]
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue")
        let cell = sender as! UITableViewCell
        let indexPath = categoryTableView.indexPathForCell(cell)
        let category = categories![indexPath!.row]
        print(category)
        let businessViewController = segue.destinationViewController as! BusinessesViewController
        
        businessViewController.category = category

    }
    

}
