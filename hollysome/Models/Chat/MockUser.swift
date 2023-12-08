//
//  MockUser.swift
//  hollysome
//

import Foundation
import MessageKit

struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
