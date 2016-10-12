//
//  EmotionsVC.swift
//  SmileyFace
//
//  Created by Mehul Gupta on 10/12/16.
//  Copyright © 2016 Mehul Gupta. All rights reserved.
//

import UIKit

class EmotionsVC: UIViewController {

    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
        
    ]
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let facevc = destinationvc as? SmileyFaceVC {
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier] {
                    facevc.expression = expression
                    
                    if let emotionTitle = sender as? UIButton{
                        facevc.title = emotionTitle.currentTitle
                    }
                }
            }
        }
        
    
    }

}
