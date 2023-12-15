//
//  HouseModel.swift
//  hollysome
//
//  Created by 이승아 on 12/5/23.

import Foundation
import ObjectMapper

class HouseModel: BaseModel {
  var house_img: String?
  override func mapping(map: Map) {
    super.mapping(map: map)
    
    self.house_img <- map["house_img"]
  }
}
