//
//  ViewController.swift
//  Bitcoin
//
//  Created by Justin Doan on 11/1/16.
//  Copyright © 2016 Justin Doan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var currencies: [[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getCurrencies()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getCurrencies() {
        let url = URL(string: "http://api.coindesk.com/v1/bpi/supported-currencies.json")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
            self.currencies = json
            self.tableView.reloadData()
        }
        
        task.resume()
    }

    ////does not change before return is called
    func getRate(code: String) -> String {
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/\(code).json")
        
        var rate = "x"
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            print(json)
            let bpi = json["bpi"] as! [String:Any]
            let code = bpi[code] as! [String:Any]
            print("RATE:  \(code["rate"]!)")
            rate = code["rate"] as! String
            
        }
        task.resume()
        
        return rate
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        getCurrencies()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currency = currencies[indexPath.row]
        let code = currency["currency"] as! String
        let country = currency["country"] as! String
        
        cell.textLabel?.text = code + ": " + country
        
        ////does not change rate before return is called
        //cell.detailTextLabel?.text = "\(getRate(code: code))"
        ////putting full function in here for now
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/\(code).json")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            //print(json)
            let bpi = json["bpi"] as! [String:Any]
            let code = bpi[code] as! [String:Any]
            let rate = code["rate_float"] as! Double
            //print("RATE:  \(code["rate"]!)")
            
            cell.detailTextLabel?.text = "\(rate)"
            
        }
        task.resume()
        
        ///////
        
        
        return cell
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

