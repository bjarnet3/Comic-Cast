//
//  Extensions.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

extension UIImageView {
    /**
     Load Image from Catch or Get from URL function
     
     [Tutorial on YouTube]:
     https://www.youtube.com/watch?v=GX4mcOOUrWQ "Click to Go"
     
     [Tutorial on YouTube] made by **Brian Voong**
     
     - parameter urlString: URL to the image
     */
    func loadImageUsingCacheWith(urlString: String, completion: Completion? = nil) {
        // print("-- loadImageUsingCacheWith --")
        let urlNSString = urlString as NSString
        
        // set initial image to nil so it doesn't use the image from a reused cell
        // image = nil
        
        // Check cache for image first
        if let cacheImage = imageCache.object(forKey: urlNSString) {
            self.image = cacheImage
            // print("found Image=\(urlString) in imageCache (loadImageUsingCacheWith)")
            completion?()
            return
        }
        // If not,, download with dispatchqueue
        let url = URL(string: urlString)
        // URL Request
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            // Run on its own threads with DispatchQueue
            DispatchQueue.main.async(execute: { () -> Void in
                if let downloadedImage = UIImage(data: data!) {
                    self.image = downloadedImage
                    // print("set image=\(urlString) in (loadImageUsingCacheWith)")
                    imageCache.setObject(downloadedImage, forKey: urlNSString)
                    completion?()
                }
            })
        }).resume( )
    }
    
}
