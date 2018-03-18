//
//  SearchResultsVC.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 4/26/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchResultsVC: UIViewController {

var serarchController: UISearchController!
@IBOutlet weak var searchInitialView: UIView!
fileprivate var suggestionArray:[String] = []


var searchArray:[String] = []
var didClickAtword:((_ word:String)->Void)?


fileprivate lazy var detailVC: DetailsSearchVC = {
    // Load Storyboard
    let storyboard = UIStoryboard(name: "Dictionary", bundle: Bundle.main)
    
    // Instantiate View Controller
    var viewController = storyboard.instantiateViewController(withIdentifier: "DetailsSearchVC") as! DetailsSearchVC
    return viewController
}()



@IBOutlet weak var tableView: UITableView!
override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight =  96
    
    let nib = UINib(nibName: "NodataFoundCellTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "NodataFoundCellTableViewCell")
    
    tableView.dataSource = self
    tableView.delegate = self
    
    
    // Do any additional setup after loading the view.
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

func filterContentForSearchText(_ searchText: String) {
    
        suggestionArray = searchArray.filter({( suggStr : String) -> Bool in
                return  suggStr.lowercased().contains(searchText.lowercased())
        })

    
    tableView.reloadData()
    

    
}
    
   
    

func fetchDataFromApi(Str:String){
    searchArray.removeAll(keepingCapacity: false)
    
    let queue = DispatchQueue(label: "com.search.response-queue", qos: .utility, attributes: [.concurrent])
    
    let parameters = ["input":Str, "profileId":5465465] as [String : Any]
    
    Alamofire.request("http://bot.ggdev.xyz/api/v1/bots/autocomplete", method: .post, parameters: parameters).response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { (response) in
        
        switch response.result {
        case .success:
            // print(response.result.value ?? "Url Not available")
            
            if let responseData  = response.result.value{
                
                let responseValue = JSON(responseData)
                
                // print(responseValue)
                
                if let dic = responseValue.dictionary, let data  =  dic["words"]?.array{
                    
                    for wordValue in data.enumerated(){
                        
                        if let  word = wordValue.element["word"].string{
                            
                            self.searchArray.append(word)
                        }
                        
                    }
                    self.suggestionArray = self.searchArray
                    
                    
                    DispatchQueue.main.async {

                        let searchText =  self.serarchController.searchBar.text
                        
                        self.filterContentForSearchText(searchText!)
                        
                    }
                    
                    
                }
                
            }
            
        case .failure(let error):
            print(error)
        }
        
    }
    
}
}

extension SearchResultsVC :UITableViewDataSource{

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if serarchController.isActive && serarchController.searchBar.text != ""{
        if suggestionArray.count > 0{
            return suggestionArray.count
          }
        }
     return 1

}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     let  cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
    
    if serarchController.isActive && serarchController.searchBar.text != "" &&  suggestionArray.count > 0{
       
                //as! SearchTableViewCell
                cell?.textLabel?.text  = suggestionArray[indexPath.row]
                cell?.imageView?.image = nil
                cell?.textLabel?.textColor = UIColor.black
        
        
        }else{
          //if  suggestionArray.count == 0 {
          cell?.textLabel?.text = "No match found.Check spelling please"
          cell?.textLabel?.textColor = UIColor.blue
          cell?.imageView?.image =  #imageLiteral(resourceName: "search_list_icon")
        // }
    
//                let  cell =  tableView.dequeueReusableCell(withIdentifier: "NodataFoundCellTableViewCell")! as! NodataFoundCellTableViewCell
           //     return cell
        
    }
    
    return cell!
}

        
}
extension SearchResultsVC:UITableViewDelegate{

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
   // serarchController.searchBar.endEditing(true)
    if suggestionArray.count > 0{
        let str = suggestionArray[indexPath.row]
    
        //delay(0.5, closure: {
            
             self.didClickAtword!(str)
            
    
       // })
    }
  }
}


extension SearchResultsVC:UISearchResultsUpdating{

func updateSearchResults(for searchController: UISearchController){
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
}

}
