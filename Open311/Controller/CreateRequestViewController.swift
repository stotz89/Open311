//
//  CreateRequestViewController.swift
//  Open311
//
//  Created by Philipp Stotz on 29.01.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import UIKit
import SwiftIconFont

class CreateRequestViewController: UIViewController {
    

    @IBOutlet weak var iconLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 50.0)
        iconLabel.text = String.fontAwesomeIcon("twitter")
        
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

}
