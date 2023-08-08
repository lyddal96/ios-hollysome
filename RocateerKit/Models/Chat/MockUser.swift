//
//  MockUser.swift
//  RocateerKit
//
//  Created by rocateer on 2020/03/31.
//  Copyright © 2020 rocateer. All rights reserved.
//

import Foundation
import MessageKit

struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
