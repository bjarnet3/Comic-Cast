//
//  Functions.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit
import MapKit

/// Haptic Engine Types
public enum HapticEngineTypes {
    case error, success, warning, light, medium, heavy, selection
}

/// haptic engine effect when pressing buttons - Parameter: Hello
public func hapticButton(_ types: HapticEngineTypes,_ fire: Bool = true) {
    if fire {
        switch types {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        default:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}

/**
 - http://nsdateformatter.com/
 
 - DateFormat = "E d MMMM h:mm"
 - TimeZone = TimeZone(secondsFromGMT: 86400)
 - Locale = Locale(identifier: "nb_NO")
 
 - Returns: **E d MMMM h:mm** ex: (**tir. 5 juni 9:04**)
 */
public func dateTimeToString(from date: Date, with locale:String = "nb_NO", dateFormat:String = "E d MMMM H:mm") -> String {
    let dateFormater = DateFormatter()
    
    dateFormater.dateFormat = "E d MMMM H:mm"
    dateFormater.timeZone = TimeZone(secondsFromGMT: 86400)
    dateFormater.locale = Locale(identifier: locale)
    
    let dateTimeToString = dateFormater.string(from: date)
    return dateTimeToString
}


/**
 Argument String in format **MM/dd/yyyy** and returns a Date
 - example: **stringToDate("12/31/2017")**
 
 - Parameter dateString: **MM/dd/yyyy**
 - Returns: **Date**
 */
public func stringToDate(_ date: String) -> Date {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
    
    let stringToDateFormat = dateFormater.date(from: date)
    return stringToDateFormat!
}

/**
 - DateFormat = "yyyy-MM-dd-HH:mm:ss"

 - Parameter date:
 - Returns: **String**
 
 - Returns: **yyyy-MM-dd-HH:mm:ss** ex: (**2017-12-31-17:40:59**)
 */
public func dateToString(_ date: Date? = nil) -> String {
    let date = date ?? Date()
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
    
    return dateFormater.string(from: date)
}


/// argument **String** of **#HEX** returns **UIColor** value
public func hexStringToUIColor (_ hex:String, _ alpha: Float? = 1.0) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
    
    if (cString.hasPrefix("#")) {
        // let index: String.Index = cString.index(cString.startIndex, offsetBy: 1)
        // cString = cString.substring(from: index) // "Stack"
        cString.removeFirst()// String(cString[index...cString.endIndex])
    }
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha!)
    )
}

/// animate imageView or View (parallax Effect)
public func addParallaxEffectOnView<T>(_ view: T, _ relativeMotionValue: Int) {
    let relativeMotionValue = relativeMotionValue
    let verticalMotionEffect : UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                                                                                         type: .tiltAlongVerticalAxis)
    verticalMotionEffect.minimumRelativeValue = -relativeMotionValue
    verticalMotionEffect.maximumRelativeValue = relativeMotionValue
    
    let horizontalMotionEffect : UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                                                                                           type: .tiltAlongHorizontalAxis)
    horizontalMotionEffect.minimumRelativeValue = -relativeMotionValue
    horizontalMotionEffect.maximumRelativeValue = relativeMotionValue
    
    let group : UIMotionEffectGroup = UIMotionEffectGroup()
    group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
    
    if let view = view as? UIView {
        view.addMotionEffect(group)
    } else {
        print("unable to add parallax Effect on View / ImageView")
    }
    
}

/// removes motionEffects (on view), if any
public func removeParallaxEffectOnView(_ view: UIView) {
    let motionEffects = view.motionEffects
    for motion in motionEffects {
        view.removeMotionEffect(motion)
    }
}

/// Animate only chosen sequence of cells with delay
/// -------------------------------------
public func animate(in collectionView: UICollectionView, completion: Completion? = nil) {
    let delay = 0.02
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        collectionView.alpha = 0
        
        let cells = collectionView.visibleCells
        let sections = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)
        
        for cell in cells { cell.alpha = 0 }
        for section in sections { section.alpha = 0 }
        
        collectionView.alpha = 1
        
        var index = 0
        for cell in cells {
            cell.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
            UIView.animate(withDuration: 0.805, delay: 0.050 * Double(index), usingSpringWithDamping: 1.3, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell.alpha = 1
                cell.updateFocusIfNeeded()
            })
            index += 1
        }
        
        var idx = 0
        for section in sections {
            section.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
            UIView.animate(withDuration: 0.505, delay: 0.06 * Double(index), usingSpringWithDamping: 1.3, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: {
                
                section.transform = CGAffineTransform(scaleX: 1, y: 1)
                section.alpha = 1
                section.updateFocusIfNeeded()
            })
            idx += 1
        }
        completion?()
    }
}

/// Animate only chosen sequence of cells with delay
/// -------------------------------------
public func animate(out collectionView: UICollectionView, completion: Completion? = nil) {
    let delay = 0.02
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        collectionView.alpha = 1
        
        let cells = collectionView.visibleCells
        let sections = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)
        
        for cell in cells { cell.alpha = 1 }
        for section in sections { section.alpha = 1}

        var index = 0
        for cell in cells {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.705, delay: 0.065 * Double(index), usingSpringWithDamping: 1.3, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: {
                
                cell.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                cell.alpha = 0
                cell.updateFocusIfNeeded()
            })
            index += 1
        }
        
        var idx = 0
        for section in sections {
            section.transform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.705, delay: 0.06 * Double(index), usingSpringWithDamping: 1.3, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: {
                
                section.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
                section.alpha = 0
                section.updateFocusIfNeeded()
            })
            idx += 1
        }
        
        completion?()
    }
}
/*
public func setMapBackgroundOverlay(mapName: MapStyleForView, mapView: MKMapView) {
    // We first need to have the path of the overlay configuration JSON
    guard let overlayFileURLString = Bundle.main.path(forResource: mapName.rawValue, ofType: "json") else {
        return
    }
    let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
    // After that, you can create the tile overlay using MapKitGoogleStyler
    guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
        return
    }
    // And finally add it to your MKMapView
    mapView.add(tileOverlay)
}
 */

// Overlay / MapOverlay
// -------------------
public func addCirleMaskWithFrostOn(_ subView: UIView) {
    // Create the view
    let blurEffect = UIBlurEffect(style: .extraLight)
    let maskView = UIVisualEffectView(effect: blurEffect)
    maskView.frame = subView.bounds
    
    // Set the radius to 1/3 of the screen width
    let radius : CGFloat = subView.bounds.width / 2.6 //  subView.bounds.width/2.6
    
    // Create a path with the rectangle in it.
    let path = UIBezierPath(rect: subView.bounds)
    // Put a circle path in the middle
    path.addArc(withCenter: subView.center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*CGFloat.pi), clockwise: true)
    
    // Create the shapeLayer
    // ---------------------
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
    
    // Create the boarderLayer
    // -----------------------
    let boarderLayer = CAShapeLayer()
    boarderLayer.path = UIBezierPath(arcCenter: subView.center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*CGFloat.pi), clockwise: true).cgPath
    boarderLayer.lineWidth = 1.5
    boarderLayer.strokeColor = UIColor.white.cgColor
    boarderLayer.fillColor = nil
    
    // add shapeLayer to maskView
    maskView.layer.mask = shapeLayer
    // set properties
    maskView.clipsToBounds = false
    maskView.layer.borderColor = UIColor.gray.cgColor
    maskView.backgroundColor = nil
    // maskView.layer.masksToBounds = true
    maskView.layer.addSublayer(boarderLayer)
    // add mask to mapView
    addParallaxEffectOnView(maskView, 12)
    subView.addSubview(maskView)
}
