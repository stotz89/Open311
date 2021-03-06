//
//  CategoryViewController.swift
//  Open311
//
//  Created by Philipp Stotz on 27.01.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class CategoryTableViewController: UITableViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    
    
    //let mUrlBostonServices = "https://311.boston.gov/open311/v2/services.json"
    //let mUrlChicago = "http://test311api.cityofchicago.org/open311/v2/services.json"
    //let mUrlToronto = "https://secure.toronto.ca/open311test/ws/services.json?jurisdiction_id=toronto.ca"
    //let mUrlKoelnProd = "https://sags-uns.stadt-koeln.de/georeport/v2/services.json?jurisdiction_id=stadt-koeln.de"
    let mUrlSanFran = "http://mobile311.sfgov.org/open311/v2/services.json?jurisdiction_id=sfgov.org"
    
    var mServiceCategoryArray : [ServiceModel] = [ServiceModel]()
    //var mRequests : [RequestModel] = [RequestModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getOpen311Services()
        
        categoryTableView.register(UINib(nibName: "ServiceCategoryCell", bundle: nil), forCellReuseIdentifier: "serviceCategoryCell")
        categoryTableView.rowHeight = 80
        SVProgressHUD.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Stuff
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mServiceCategoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "serviceCategoryCell", for: indexPath) as! ServiceCategoryCell
        
        categoryCell.categoryName.text = mServiceCategoryArray[indexPath.row].serviceName
        categoryCell.categoryDescription.text = mServiceCategoryArray[indexPath.row].description
        
        return categoryCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Button pressed")
        
        performSegue(withIdentifier: "showRequests", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RequestTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.service = mServiceCategoryArray[indexPath.row]
        }
    }
    
    
    //MARK: HTTP Requests
    
    func getOpen311Services() {
        print("Fire for Services.....")
        
        Alamofire.request(mUrlSanFran, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success!")
                let resJson : JSON = JSON(response.result.value!)
                print("Parsing JSON.....")
                self.parseServiceJson(json: resJson)
                
            }
            else {
                print(response.result.error!)
            }
            SVProgressHUD.dismiss()
            self.categoryTableView.reloadData()
            print("Done with HTTP")
        }
    }
    
    //MARK: JSON Parsing
    
    func parseServiceJson(json : JSON) {
        for (_, req) in json {
            
            let serviceModel = ServiceModel()
            
            //print(req)
            if req["service_code"].string != nil {
                serviceModel.serviceCode = req["service_code"].string!
            }
            if req["service_name"].string != nil {
                serviceModel.serviceName = req["service_name"].string!
            }
            if req["description"].string != nil {
                serviceModel.description = req["description"].string!
            }
            if req["metadata"].string != nil {
                serviceModel.metadata = req["metadata"].string!
            }
            if req["type"].string != nil {
                serviceModel.type = req["type"].string!
            }
            if req["group"].string != nil {
                serviceModel.group = req["group"].string!
            }
            
            mServiceCategoryArray.append(serviceModel)
        }
    }
    
    
}

//MARK: Search Bar Methods
extension CategoryTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

