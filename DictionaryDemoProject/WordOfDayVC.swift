//
//  WordOfDayVC.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 4/26/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WordOfDayVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var recentwordArray = NSMutableArray()
    var path:String?
    fileprivate var wordDayStr:String?
    
    var didClickAtword:((_ word:String)->Void)?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
       // print(tableView.contentInset)
        
        //self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        let queue = DispatchQueue(label: "com.search.response-queue", qos: .utility, attributes: [.concurrent])

       
        
        Alamofire.request("http://bot.ggdev.xyz/api/v1/bots/dictionary/wordoftheday", method: .post).response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { (response) in
            
            switch response.result {
            case .success:
                
                if let responseData  = response.result.value{
                    
                    let responseValue = JSON(responseData)
                    
                    guard let dic  = responseValue.dictionary, let wordOfTheDay = dic["wordOfTheDay"]?.string  else{ return }
                    
                    DispatchQueue.main.async {
                        self.wordDayStr = wordOfTheDay
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.setRecentWordList()
                    }
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setRecentWordList(){
        
         if let plistPath = path{
            
           // print(plistPath)
            
        recentwordArray.removeAllObjects()
        // Extract the content of the file as NSData
        let data:Data =  FileManager.default.contents(atPath: plistPath)!
        do{
            recentwordArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
           
        }catch{
            print("Error occured while reading from the plist file")
        }
        self.tableView.reloadData()


    }
    
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
//    func clickwordOFDayLabel(){
//        
//        didClickAtword!(self.wordOFDayLabel.text!)
//        
//    }
    
}

extension WordOfDayVC:UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  section == 0{
            return 1
        }else{
            if recentwordArray.count > 0{
                return recentwordArray.count
            }else{
               return 1
            }
    }
}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordsDayTableViewCell") as? WordsDayTableViewCell
        

        
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        if indexPath.section == 0 && indexPath.row == 0{
           
            cell?.wordLabel?.text = wordDayStr
            cell?.wordLabel.font = UIFont.systemFont(ofSize: 30.0, weight: UIFontWeightRegular)
            //cell?.wordLabel.textColor =
           
            
        }else if indexPath.section == 1{
            cell?.wordLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightRegular)
            if recentwordArray.count > 0 {
                cell?.wordLabel?.text = recentwordArray.object(at: indexPath.row) as? String
                cell?.wordLabel?.textAlignment = .left
            }else{
                cell?.wordLabel?.text = "Your Search Will Appear here"
                cell?.wordLabel?.textAlignment = .center
               // cell?.wordLabel.textColor =

            }
          
        }
        

        return cell!
        
    }
    
}

extension WordOfDayVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if indexPath.section == 0{
          didClickAtword!(wordDayStr!)
        }else{
            if recentwordArray.count>0{
                didClickAtword!(self.recentwordArray[indexPath.row] as! String)
            }
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let nibView = Bundle.main.loadNibNamed("WordDayHeader", owner: nil, options: nil)?.first as! WordOfDayHeader
        nibView.titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightBold)
        if section == 0{
         nibView.titleLabel.text = "WORD OF THE DAY"
         
        // nibView.titleLabel.backgroundColor = UIColor.yellow
        }else{
         nibView.titleLabel.text = "RECENT WORDS"
        }
    return nibView
        

    }

  
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    if indexPath.row == self.tableView.numberOfRows(inSection: indexPath.section) - 1 {
               cell.roundCorners([.bottomRight, .bottomLeft], 8.0)
        }else {
           cell.roundCorners([.bottomRight, .bottomLeft], 0.0)
         }
 
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
           return 60
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let v = UIView()
//            if section == 0{
//                v.backgroundColor = UIColor.clear
//            }else{
//                v.backgroundColor = UIColor.white
//                v.roundCorners([.bottomRight, .bottomLeft], 8.0)
//            }
            

            return v
        }
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 10
    }

    
}
