//
//  LanguageSettingViewController.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 5/4/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit

class LanguageSettingVC: UIViewController {

    @IBOutlet weak var toPickerView: UIPickerView!
    @IBOutlet weak var fromPickerView: UIPickerView!
    
    var pickerArray = ["English", "Bengali","Japan", "Dutch", "French","German", "Italy","Hindi","Chinese"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        toPickerView.delegate = self
        toPickerView.dataSource = self
        fromPickerView.delegate = self
        fromPickerView.dataSource = self
        fromPickerView.selectRow(4, inComponent: 0, animated: true)
        toPickerView.selectRow(5, inComponent: 0, animated: true)

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
    
    @IBAction func doneBtnClick(_ sender: Any) {
        
       print( fromPickerView.selectedRow(inComponent: 0))
        print(toPickerView.selectedRow(inComponent: 0))
        
       self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelBtnClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
}



extension LanguageSettingVC : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }

}
extension LanguageSettingVC:UIPickerViewDelegate{

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(pickerArray[row])
    }
}
