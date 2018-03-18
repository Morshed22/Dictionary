//
//  ViewController.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 4/25/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

import UIKit

class GGDictionaryVC: UIViewController {

    var popover:Popover?
    var plistPathInDocument:String = String()
     
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    var searchController: UISearchController?
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    fileprivate lazy var wordOfDayVC: WordOfDayVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Dictionary", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "WordOfDayVC") as! WordOfDayVC
        viewController.didClickAtword = {[weak self]  word in
              self?.addDetailsVC(word: word)
        }
        return viewController
    }()
    
    
    
    
    
    fileprivate lazy var favouriteListVC: FavouriteListVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Dictionary", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "FavouriteListVC") as! FavouriteListVC
        viewController.didClickAtword = {[weak self]  word in
            self?.addDetailsVC(word: word)
        }
        return viewController
    }()

    
    
  
    fileprivate lazy var SearchResultsVC: SearchResultsVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Dictionary", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SearchResultsVC") as! SearchResultsVC
        
        viewController.didClickAtword = {[weak self]  word in
            self?.addDetailsVC(word: word)
        }
        return viewController
    }()
    
   

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    self.preparePlistForUse()
    wordOfDayVC.path = plistPathInDocument
    self.add(asChildViewController: wordOfDayVC)
        
    self.addSearchController()
        
    }

    fileprivate  func addSearchController(){
    
        searchController = ({
            searchController = UISearchController(searchResultsController: nil)
            searchController?.searchResultsUpdater = SearchResultsVC
            searchController?.hidesNavigationBarDuringPresentation = true
            searchController?.dimsBackgroundDuringPresentation = false
            //setup the search bar
            searchController?.searchBar.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            self.searchContainerView?.addSubview((searchController?.searchBar)!)
            searchController?.searchBar.delegate = self
//            searchController?.searchBar.scopeButtonTitles = ["Matches", "Letter List"]
            searchController?.searchBar.sizeToFit()
            searchController?.searchBar.barTintColor = UIColor.blue
            searchController?.searchBar.placeholder = "Enter Keyword"
            searchController?.searchBar.returnKeyType = .default
            searchController?.searchBar.tintColor = UIColor.white
         let _  = searchController?.searchBar.subviews[0].subviews.filter({$0.isKind(of: UITextField.self)}).map(
                {$0.tintColor = .lightGray}
            )

            return searchController
        })()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addDetailsVC(word:String){
        
         searchController?.searchBar.becomeFirstResponder()
            let storyboard = UIStoryboard(name: "Dictionary", bundle: Bundle.main)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsSearchVC") as! DetailsSearchVC
            detailVC.word = word
            detailVC.path = plistPathInDocument
        detailVC.keyBoardOFF = {
        
        self.searchController?.searchBar.endEditing(true)
        }
        
        searchController?.searchBar.text = word
//
        add(asChildViewController: detailVC)
        
    }
    
    
    func preparePlistForUse(){
        // 1
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        // 2
        plistPathInDocument = rootPath + "/recentSearch.plist"
        if !FileManager.default.fileExists(atPath: plistPathInDocument){
            let plistPathInBundle = Bundle.main.path(forResource: "recentSearch", ofType: "plist") as String!
            // 3
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: plistPathInDocument)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
    
    @IBAction func favouritesAction(_ sender: UIBarButtonItem) {
        
     let v = sender.value(forKey: "view") as! UIView

        let width = self.view.frame.width
        let popView = Bundle.main.loadNibNamed("PopMenuItemView", owner: self, options: nil)?.first as! PopMenuItemView
        popView.favorlagDelegate = self
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 127))
        popView.frame = aView.bounds
        aView.addSubview(popView)
        
        if self.childViewControllers.last is WordOfDayVC {
            
            popView.favOrworDayBtn.setTitle("Favourite Word", for: .normal)
            popView.favOrworDayBtn.setImage(#imageLiteral(resourceName: "favourite_icon"), for: .normal)
            
        }else if self.childViewControllers.last is FavouriteListVC{
            
            popView.favOrworDayBtn.setTitle("Home", for: .normal)
             popView.favOrworDayBtn.setImage(#imageLiteral(resourceName: "home_icon"), for: .normal)
        }

         popover = Popover(options: [.cornerRadius(0)], showHandler: nil, dismissHandler: nil)
        
                popover?.show(aView, fromView: v)
    
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "languageChange"{
            
            let languageSettingVC  =  segue.destination as! LanguageSettingVC
            slideInTransitioningDelegate.direction = .bottom
            slideInTransitioningDelegate.disableCompactHeight = true
            languageSettingVC.transitioningDelegate = slideInTransitioningDelegate
            languageSettingVC.modalPresentationStyle = .custom
        
        }
    }
    
  
    @IBAction func languageChangeAction(_ sender: Any) {
        self.performSegue(withIdentifier: "languageChange", sender: self)
    }
    
    
 
   func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.didMove(toParentViewController: self)
    }
    
   func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    

}



extension GGDictionaryVC: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        
        if self.childViewControllers.last is DetailsSearchVC {
           let detailsVC =  self.childViewControllers.last as! DetailsSearchVC
            self.remove(asChildViewController: detailsVC)
            
        }else if self.childViewControllers.last is FavouriteListVC {
            let favVC =  self.childViewControllers.last as! FavouriteListVC
            self.remove(asChildViewController: favVC)
            SearchResultsVC.serarchController = searchController
            self.add(asChildViewController: SearchResultsVC)
        }else if self.childViewControllers.last is WordOfDayVC && searchBar.text == ""{
            SearchResultsVC.serarchController = searchController
            self.add(asChildViewController: SearchResultsVC)
        }
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if self.childViewControllers.last is DetailsSearchVC {
            let detailsVC =  self.childViewControllers.last as! DetailsSearchVC
            self.remove(asChildViewController: detailsVC)
            
        }
        self.remove(asChildViewController: SearchResultsVC)
        wordOfDayVC.setRecentWordList()
        
        
        
    }
    
  
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
      if  searchText.characters.count == 2 {
        SearchResultsVC.fetchDataFromApi(Str: searchText)
        if self.childViewControllers.last is DetailsSearchVC {
            let detailsVC =  self.childViewControllers.last as! DetailsSearchVC
            self.remove(asChildViewController: detailsVC)
        }
    }
        
    }

   

    
}



extension GGDictionaryVC:PopMenuItemViewProtocol {
    
        func favorlanBtnClck(item:String,popview:PopMenuItemView){

            self.popover?.dismiss()

                if item == "language"{
                    self.performSegue(withIdentifier: "languageChange", sender: self)
                }else{
                    if self.childViewControllers.last is WordOfDayVC {
                        //self.remove(asChildViewController: self.WordOfDayVC)
                        self.add(asChildViewController: self.favouriteListVC)
                        
                    }else if self.childViewControllers.last is FavouriteListVC{
                        self.remove(asChildViewController: self.favouriteListVC)
                        //self.add(asChildViewController: self.WordOfDayVC)
                        
                        
                    }
                }
    }

    
    

}

