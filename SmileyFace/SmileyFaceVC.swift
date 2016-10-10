//
//  SmileyFaceVC.swift
//  SmileyFace
//
//  Created by Mehul Gupta on 10/10/16.
//  Copyright © 2016 Mehul Gupta. All rights reserved.
//

import UIKit

class SmileyFaceVC: UIViewController {
    
    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Smirk){ didSet{ updateFaceView() } }
    
    @IBOutlet weak var faceView: FaceView!{ didSet{ updateFaceView() } }
    
    private func updateFaceView(){
        
        switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyesBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    }

    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Smirk: -0.5, .Neutral: 0.0, .Grin: 0.5, .Smile: 1.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5, .Normal: 0.0, .Furrowed: -0.5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

