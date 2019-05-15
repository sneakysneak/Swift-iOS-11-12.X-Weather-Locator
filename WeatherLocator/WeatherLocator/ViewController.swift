//
//  ViewController.swift
//  WeatherLocator
//
//  Created by sneakysneak on 22/11/2018.
//  Copyright © 2018 sneakysneak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet var txtfCity: UITextField!
    
    @IBOutlet var lblResult: UILabel!
    
    @IBAction func btnGetWeather(_ sender: Any) {
        //In order to search cities like El Salvador, swap all " " white space with "-"
        if let url = URL(string: "https://www.weather-forecast.com/locations/" +
            txtfCity.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            
            if let error = error {
                
                print(error)
                
            } else {
                
                if let unwrappedData = data {
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    //                    var stringSeparator = "London Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                    var stringSeparator = "</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 {
                            
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 0 {
                                //replace in the string array a special string piece
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                
                                print(message)
                                
                            }
                        }
                    }
                }
            }
            if message == "" {
                message = "There is no such city. Try again."
            }
            
            //            DispatchQueue.main.sync(execute: {
            //                //need self. want to refer to outside the viewcontroller closure
            //                lblResult.text = message
            //            })
            DispatchQueue.main.sync(execute: {
                self.lblResult.text = message
            })
        }
        
        task.resume()
        } else {
            //don't need self because not inside the task or closure
            lblResult.text = "There is no such city. Try again."
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

}
