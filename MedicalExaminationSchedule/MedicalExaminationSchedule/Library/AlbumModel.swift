//
//  AlbumModel.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/18/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import Foundation
import Photos

public class AlbumModel{
    let name:String
    let count:Int
    let collection:PHAssetCollection
    init(name:String, count:Int, collection:PHAssetCollection) {
        self.name = name
        self.count = count
        self.collection = collection
    }
}
