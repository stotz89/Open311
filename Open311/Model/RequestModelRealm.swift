//
//  RequestModelRealm.swift
//  Open311
//
//  Created by Philipp Stotz on 01.04.18.
//  Copyright © 2018 Philipp Stotz. All rights reserved.
//

import Foundation
import RealmSwift

class RequestModelRealm: Object {
    
    @objc dynamic var serviceRequestId : String = ""
    @objc dynamic var serviceName : String = ""
    @objc dynamic var serviceCode : String = ""
    @objc dynamic var RequestDescription : String = ""
    
}
