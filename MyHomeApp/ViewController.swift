//
//  ViewController.swift
//  MyHomeApp
//
//  Created by Jakub Gwóźdź on 10/11/2018.
//  Copyright © 2018 Jakub Gwóźdź. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    
    @IBOutlet weak var floor1Light: UISwitch!
    @IBOutlet weak var floor1Tempreature: UILabel!
    @IBOutlet weak var floor1Humidity: UILabel!
    var f1Temp = 25.6 {
        didSet{
            floor1Tempreature.text = "\(f1Temp)°C"
        }
    }
    var f1Hum = 50.0 {
        didSet{
            floor1Humidity.text = "\(f1Hum)%"
        }
    }
    
    @IBOutlet weak var floor2Light: UISwitch!
    @IBOutlet weak var floor2Temperature: UILabel!
    @IBOutlet weak var floor2Humidity: UILabel!
    var f2Temp = 0.0 {
        didSet{
            floor2Temperature.text = "\(f2Temp)°C"
        }
    }
    var f2Hum = 0.0 {
        didSet{
            floor2Humidity.text = "\(f2Hum)%"
        }
    }
    
    lazy var data = NSMutableData()
    var timer: Timer?

    
    override func viewDidLoad() {
        updateDataFromESPserver()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.updateDataFromESPserver), userInfo: nil, repeats: true)

    }
    
    @objc func updateDataFromESPserver(){
        URLSession.shared.dataTask(with: URL(string: "http://myhome.local")!) { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                    // Convert to dictionary where keys are of type String, and values are of any type
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let floor1 = json["FLOOR1"] as? [String: Any]
                    let floor2 = json["FLOOR2"] as? [String: Any]
                    self.f1Temp = floor1!["temperature"] as! Double
                    self.f1Hum = floor1!["humidity"] as! Double
                    if(floor1!["light"] as! Int == 1){
                        self.floor1Light.setOn(true, animated: false)
                    } else{
                        self.floor1Light.setOn(false, animated: false)
                    }
                    
                    self.f2Temp = floor2!["temperature"] as! Double
                    self.f2Hum = floor2!["humidity"] as! Double
                    if(floor2!["light"] as! Int == 1){
                        self.floor2Light.setOn(true, animated: false)
                    } else{
                        self.floor2Light.setOn(false, animated: false)
                    }
        
                } catch {
                    // Something went wrong
                }
            }
            }.resume()
        
    }
    
    @IBAction func floor1ChangeLight(_ sender: Any) {
        if floor1Light.isOn{
            URLSession.shared.dataTask(with: URL(string: "http://myhome.local/floor1ON")!) { (data, response, error) -> Void in
                }.resume()
        } else {
            URLSession.shared.dataTask(with: URL(string: "http://myhome.local/floor1OFF")!) { (data, response, error) -> Void in
            }.resume()
        }
    }
    
    
    @IBAction func floor2ChangeLigh(_ sender: Any) {
        if floor2Light.isOn{
            URLSession.shared.dataTask(with: URL(string: "http://myhome.local/floor1ON")!) { (data, response, error) -> Void in
                }.resume()
        } else {
            URLSession.shared.dataTask(with: URL(string: "http://myhome.local/floor2OFF")!) { (data, response, error) -> Void in
                }.resume()
        }
    }
    
    

}

