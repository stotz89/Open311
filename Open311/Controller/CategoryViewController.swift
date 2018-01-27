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

class CategoryViewController: UITableViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    
    
    let mUrlBostonServices = "https://311.boston.gov/open311/v2/services.json"
    let mUrlChicago = "http://test311api.cityofchicago.org/open311/v2/requests.json?jurisdiction_id=cityofchicago.org"
    
    var mServiceCategoryArray : [ServiceModel] = [ServiceModel]()
    var mRequests : [RequestModel] = [RequestModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getOpen311Services()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        categoryTableView.register(UINib(nibName: "ServiceCategoryCell", bundle: nil), forCellReuseIdentifier: "serviceCategoryCell")
        
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
        
        return categoryCell
    }
    
    //MARK: HTTP Requests
    
    func getOpen311Services() {
        print("Fire for Services.....")
        
        Alamofire.request(mUrlBostonServices, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let resJson : JSON = JSON(response.result.value!)
                print("Parsing JSON.....")
                self.parseServiceJson(json: resJson)
                
            }
            else {
                print(response.result.error!)
            }
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
    
    func parseRequestJson(json : JSON) {
        for (_, req) in json {
            
            let requestModel = RequestModel()
            
            //print(req)
            if req["status"].string != nil {
                requestModel.status = req["status"].string!
            }
            if req["description"].string != nil {
                requestModel.description = req["description"].string!
            }
            if req["adress"].string != nil {
                requestModel.address = req["address"].string!
            }
            if req["lat"].string != nil {
                requestModel.lat = req["lat"].string!
            }
            if req["long"].string != nil {
                requestModel.long = req["long"].string!
            }
            if req["service_name"].string != nil {
                requestModel.serviceName = req["service_name"].string!
            }
            
            mRequests.append(requestModel)
        }
    }
}

