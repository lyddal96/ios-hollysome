//
//  ImageModel.swift
//  hollysome
//
//  Created by rocateer on 2020/01/03.
//  Copyright © 2020 rocateer. All rights reserved.
//

import Foundation
import ObjectMapper

class ImageModel: BaseModel {
  var path: String?
  // 이미지 가로 길이
  var width: Int?
  // 이미지 세로 길이
  var height: Int?

  var result: ImageModel?
  var data: [ImageModel]?
  var image_ids: [Int]?

  
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.path <- map["path"]
    self.width <- map["width"]
    self.height <- map["height"]

    self.result <- map["result"]
    self.data <- map["data"]
    self.image_ids <- map["image_ids"]

  }
  
}
