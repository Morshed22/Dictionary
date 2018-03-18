//
//  SingleCharacterWordListVC.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 5/9/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class FavouriteListVC: UIViewController {
    
    var favArray = [String]()
     var noWordView = UIView()
    
    @IBOutlet weak var tableView: UITableView!
    var didClickAtword:((_ word:String)->Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.favArray.removeAll(keepingCapacity: false)
        let queue = DispatchQueue(label: "com.search.response-queue", qos: .utility, attributes: [.concurrent])
        
        let parameters = ["profileId":55043] as [String : Any]

        Alamofire.request("http://bot.ggdev.xyz/api/v1/bots/dictionary/dictionaryfavotitelist", method: .post, parameters: parameters).response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { (response) in
            
            switch response.result {
            case .success:
                // print(response.result.value ?? "Url Not available")
                
                if let responseData  = response.result.value{
                    
                    let responseValue = JSON(responseData)
                    
                    // print(responseValue)
                    
                    if let dic = responseValue.dictionary, let data  =  dic["favotiteList"]?.array{
                        
                        for wordValue in data.enumerated(){
                            
                            if let  word = wordValue.element.string{
                                
                                self.favArray.append(word)
                            }
                            
                        }
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        if self.favArray.count>0{
                            self.tableView.isHidden = false
                            self.noWordView.isHidden = true
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.tableFooterView = UIView()
                            self.tableView.reloadData()
                            
                        }else{
                            
                            self.noWordFoundView()
                        }
                    }
                    
                }
                
            case .failure(let error):
                print(error)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func noWordFoundView(){
       tableView.isHidden = true
        noWordView.isHidden = false
        
        
        noWordView.translatesAutoresizingMaskIntoConstraints = false
        
        noWordView.backgroundColor = UIColor.white
        
        view.addSubview(noWordView)
        
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[noWordView]-20-|", options: [], metrics: nil, views:["noWordView":noWordView]))
        
     NSLayoutConstraint(item: noWordView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10.0).isActive = true
        
     NSLayoutConstraint(item: noWordView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100).isActive = true
        
    noWordView.layer.cornerRadius = 8.0
     noWordView.clipsToBounds = true
        
       let nodatdlabel = UILabel()
        nodatdlabel.text = "No word has been added yet!"
        nodatdlabel.textColor = UIColor.black
        nodatdlabel.textAlignment = .center
       nodatdlabel.translatesAutoresizingMaskIntoConstraints = false
       noWordView.addSubview(nodatdlabel)
        
  noWordView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[nodatdlabel]|", options: [], metrics: nil, views:["nodatdlabel":nodatdlabel]))
 
  NSLayoutConstraint(item: nodatdlabel, attribute: .height, relatedBy: .equal, toItem: noWordView, attribute: .height, multiplier: 0.2, constant: 0).isActive = true
        
  NSLayoutConstraint(item: nodatdlabel, attribute: .centerY, relatedBy: .equal, toItem: noWordView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
    }

}

extension FavouriteListVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return self.favArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favcell")
        //cell?.contentView.layoutMargins.left = 100
       
        cell?.textLabel?.text = self.favArray[indexPath.row]
        return cell!
    }

    
}

extension FavouriteListVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if favArray.count>1{
    if indexPath.row == 0 {
          cell.roundCorners([.topLeft, .topRight], 8.0)
    }else if indexPath.row == self.tableView.numberOfRows(inSection: 0) - 1 {
        cell.roundCorners([.bottomRight, .bottomLeft], 8.0)
    }
        }else{
        cell.roundCorners([.allCorners], 8.0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // let str = suggestionArray[indexPath.row]
        
        //delay(0.5, closure: {
        
        self.didClickAtword!(self.favArray[indexPath.row])
    }
    
}
