//
//  PHFetchResultExtension.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/18/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import Foundation
import Photos

public class FetchAllPhoto {
     static func listAlbums() -> [AlbumModel] {
        var album:[AlbumModel] = [AlbumModel]()
        
//        let qryAlbums = MPMediaQuery.albumsQuery()
//        qryAlbums.groupingType = MPMediaGrouping.Album
        let options = PHFetchOptions()
        options.includeAllBurstAssets = true
        let collections = PHAssetCollection.fetchAssetCollections(with: .moment, subtype: .any, options: options)
//        let unapplied = userAlbums.enumerateObjects(_:)
//        unapplied { (object, count, stop) in
//            stop.pointee = true
//            if object is PHAssetCollection {
//                let obj:PHAssetCollection = object as! PHAssetCollection
//                
//                let fetchOptions = PHFetchOptions()
//                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
//                
//                let newAlbum = AlbumModel(name: obj.localizedTitle!, count: obj.estimatedAssetCount, collection:obj)
//                album.append(newAlbum)
//            }
//        }
        collections.enumerateObjects(_:) { (object, count, stop) in
            stop.pointee = true
            if object is PHAssetCollection {
                let obj:PHAssetCollection = object 
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                
                let newAlbum = AlbumModel(name: obj.localizedTitle!, count: obj.estimatedAssetCount, collection:obj)
                album.append(newAlbum)
            }
        }
        
//        userAlbums.enumerateObjects({ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
//            stop.pointee = true
//            if object is PHAssetCollection {
//                let obj:PHAssetCollection = object as! PHAssetCollection
//                
//                let fetchOptions = PHFetchOptions()
//                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
//                
//                let newAlbum = AlbumModel(name: obj.localizedTitle!, count: obj.estimatedAssetCount, collection:obj)
//                album.append(newAlbum)
//            }
//        })
        
        for item in album {
            print(item)
        }
        return album
    }
}

