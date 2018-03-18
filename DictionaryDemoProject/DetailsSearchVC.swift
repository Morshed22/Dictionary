//
//  DetailsViewController.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 5/8/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit

class DetailsSearchVC: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    
   var  word: String?
   var  path:String?
    
   
   var keyBoardOFF:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let word = word{
        
            let str = "http://bot.ggdev.xyz/api/v1/bots/dictionarydetails/"+"55043/"+word
        
        // Do any additional setup after loading the view.
        let request = URLRequest(url: URL(string: str)!)
            webview.loadRequest(request)
            webview.delegate = self
            
           
            self.saveItemToPlist(word: word)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(0.2, closure: {
        
        self.keyBoardOFF!()
        })
       
    }

  func  saveItemToPlist(word:String){
    
    if let pathForThePlistFile = path{
    
    // Extract the content of the file as NSData
    let data:Data =  FileManager.default.contents(atPath: pathForThePlistFile)!
    // Convert the NSData to mutable array
    do{
        var wordsArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! [String]
        
        if !wordsArray.contains(word)  {
            
            if wordsArray.count <= 20{
             wordsArray.appendAtBeginning(newItem: word)
            }else{
                wordsArray.appendAtBeginning(newItem: word)
                wordsArray.removeLast()
            
            }

        (wordsArray as NSArray).write(toFile: pathForThePlistFile, atomically: true)
        //print(wordsArray)
       }
        
    }catch{
        print("An error occurred while writing to plist")
    }
    }
    }
}
extension DetailsSearchVC : UIWebViewDelegate {
    
    //    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    //
    //       // webView.loadHTMLString("<html><head></head><body></body></html>", baseURL: nil)
    //
    //        //return true
    //   }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webView.stopLoading();
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        print(error)
        
    }
}
