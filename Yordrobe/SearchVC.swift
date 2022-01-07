//
//  SearchVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/20/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class SearchVC: UIViewController {
    
    @IBOutlet weak var aTable: UITableView!
   // @IBOutlet weak var searchBar: UISearchBar!

    let progressHUD = ProgressHUD(text: "Loading..")
    var ary_resultBrand : Array! = []
    var ary_result : Array! = []
    var isSearchClose : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup the Search Controller
        configureSearchController()
        //
        API_brand()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // searchController.isActive = false
        isSearchClose = false
        self.aTable.reloadData()
    }

    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.black
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false

        // Setup the Scope Bar
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.scopeButtonTitles = ["@User", "#Tag"]
        searchController.searchBar.delegate = self
        // searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 266, height: 100)

        searchController.searchBar.sizeToFit()
        self.aTable.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true
        
        self.aTable.layoutMargins = UIEdgeInsets.zero
        extendedLayoutIncludesOpaqueBars = true
        // self.aTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    func API_brand() {
        
        self.view.addSubview(progressHUD)
        ary_resultBrand.removeAll()
        
        let query = PFQuery(className:"Brands")
        //query.whereKey("Name", contains: name)
        
        query.findObjectsInBackground {
            (objects:[PFObject]?, error:Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!) scores.")
                //progressHUD.removeFromSuperview()
                
                // Do something with the found objects
                
                if objects!.count > 0 {
                    self.ary_resultBrand = objects
                    self.aTable.reloadData()
                }
            }
            else {
                // Log details of the failure
                print("Error: \(error!)")
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    func API_yordrobersList(userName: String?) {
        
        self.view.addSubview(progressHUD)
        ary_result.removeAll()
        
        // yordrobers list ..
        let yordrobersQuery = PFUser.query()!
        yordrobersQuery.whereKey("objectId", notEqualTo: PFUser.current()!.objectId!)
        yordrobersQuery.whereKey("firstName", notEqualTo: NSNull())
        yordrobersQuery.whereKey("username", contains: userName)
        
        
        yordrobersQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                print("Object== \(objects!)")
                
                self.ary_result = objects
                self.aTable.reloadData()
            }
            else {
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
            }
            self.progressHUD.removeFromSuperview()
        }
    }

    
    func API_hasTag(hasTag: String!) {
        self.view.addSubview(progressHUD)
        ary_result.removeAll()

        let hasTagQuery = PFQuery(className: "Tag")
        //hasTagQuery.whereKey("Description", matchesRegex: "#" + hasTag, modifiers: "i")
        hasTagQuery.whereKey("TagText", matchesRegex: hasTag, modifiers: "i")
        //hasTagQuery.whereKey("TagText", contains: hasTag)

        hasTagQuery.findObjectsInBackground { (Objects, error) in
            print("has tag == \(Objects!)")
            if error == nil {
                //if Objects!.count > 0 {
                    self.ary_result = Objects
                    self.aTable.reloadData()
                //}
            }
            else{
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
            }
            self.progressHUD.removeFromSuperview()
        }
    }
 
}

extension SearchVC : UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filterContentsforSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        searchBar.text = ""
        self.ary_result.removeAll()
        self.aTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(#function)
       // searchController.isActive = true
         isSearchClose = true
        self.aTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.selectedScopeButtonIndex == 0 {
            self.API_yordrobersList(userName: searchBar.text?.lowercased())
        }
        else if searchBar.selectedScopeButtonIndex == 1 {
             API_hasTag(hasTag: searchBar.text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
       // searchController.isActive = false
        isSearchClose = false
        self.aTable.reloadData()
    }
}


extension SearchVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterSearchController(searchController.searchBar)
    }
    
}

extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    // # Table view delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if !isSearchClose {
            return ary_resultBrand.count
        }
        else{
            return ary_result.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return !isSearchClose ? 50 : searchController.searchBar.selectedScopeButtonIndex == 0 ? 65 : 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! ProjectCell
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: !isSearchClose  ? "customCell":searchController.searchBar.selectedScopeButtonIndex == 0 ? "userCell" :"customCell")! as! ProjectCell
        
        if !isSearchClose {
            cell.lbl_title.text = "\((ary_resultBrand[indexPath.row] as! PFObject).value(forKey: "Name")!)"
        }
        else if searchController.searchBar.selectedScopeButtonIndex == 0 {
            cell.lbl_userName.text = "\((ary_result[indexPath.row] as! PFUser)["firstName"]!) \((ary_result[indexPath.row] as! PFUser)["lastName"]!)"
            cell.lbl_userID.text = "@\((ary_result[indexPath.row] as! PFUser).username!)"
            
            if let ProfilePic = (ary_result[indexPath.row] as! PFUser)["ProfilePic"]  {
                (ProfilePic as? PFFileObject)?.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        cell.img_userIcon.image = image
                    }
                })
            }
        }
        else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            //cell.lbl_title.text = "\((ary_filteredResults[indexPath.row] as! PFObject).value(forKey: "Name")!)"
            cell.lbl_title.text = "#\((ary_result[indexPath.row] as! PFObject).value(forKey: "TagText")!)"
        }
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
         if !isSearchClose {
            
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as? ProductListVC {
                viewController.isDiscover = true
                viewController.strBrand = "\((ary_resultBrand[indexPath.row] as! PFObject).value(forKey: "Name")!)"
                viewController.strTag = "no"
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
        else if searchController.searchBar.selectedScopeButtonIndex == 0  {
            
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
                viewController.isSelfUser = false
                viewController.otherUser = ary_result[indexPath.row] as! PFUser
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
         else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as? ProductListVC {
                viewController.isDiscover = true
                viewController.strTag = "\((ary_result[indexPath.row] as! PFObject).value(forKey: "TagText")!)"
                viewController.strBrand = "no"
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
       // searchController.isActive = false
        isSearchClose = false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if #available(iOS 11, *) {
            return 0
        }
        else{
            if !isSearchClose {
                return 0
            }
            else{
                return 44
            }
        }
    }
}

