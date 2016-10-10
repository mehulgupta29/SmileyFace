//
//  FaceView.swift
//  SmileyFace
//
//  Created by Mehul Gupta on 10/10/16.
//  Copyright © 2016 Mehul Gupta. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var scale:CGFloat = 0.90
    var mouthCurvature: Double = 1.0 // -1 for full frown and 1 for full smile
    var eyesOpen: Bool = true
    var eyesBrowTilt: Double = 0.0 // -1 full furrow, 1.0 full relaxed

    var skullRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    var skullCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios{
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
        static let skullRadiusToBrowOffset: CGFloat = 5
    }
    
    private enum Eye{
        case Left
        case Right
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint{
        let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye{
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath{
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        
        if eyesOpen{
            eyesBrowTilt = 0.5
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        }else{
            eyesBrowTilt = -0.5
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = 5.0
            return path
        }
    }
    
    private func pathForBrows(eye: Eye) -> UIBezierPath{
        var tilt = eyesBrowTilt
        switch eye {
        case .Left: tilt *= -1.0
        case .Right: break
        }
        
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Ratios.skullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = 5.0
        return path
    }
    
    private func pathForMouth() -> UIBezierPath{
    
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        if mouthCurvature >= 0.0 {
            eyesBrowTilt = 0.5
        }else{
            eyesBrowTilt = -0.5
        }
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY+smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY+smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        return path
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath{
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        path.lineWidth = 5.0
        return path
    }

    override func draw(_ rect: CGRect) {
        UIColor.blue.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForBrows(eye: .Left).stroke()
        pathForBrows(eye: .Right).stroke()
        
        pathForMouth().stroke()
    }

}
