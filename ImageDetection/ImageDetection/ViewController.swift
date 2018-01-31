//
//  ViewController.swift
//  ImageDetection
//
//  Created by Toshihiro Goto on 2018/01/25.
//  Copyright © 2018年 Toshihiro Goto. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	var ballCreated = false
	let newBall = SCNSphere(radius: 0.01)
	var newBallNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
		
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
		
        // Create a new scene
        let scene = SCNScene()
		
		newBallNode = SCNNode(geometry: newBall)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = [.vertical, .horizontal]

        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    }
	
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {

            if let imageAnchor = anchor as? ARImageAnchor {
				
                if(node.geometry == nil){
                    let plane = SCNPlane()
					
					
//                  node.geometry = plane
//					node.position.x = 0
//					node.position.y = 0
//					node.position.z = 0
					
					let dummyScene = SCNScene(named: "Models.scnassets/mask.scn")!
					
					
//					self.sceneView.scene.rootNode.position = node.position
					if !self.ballCreated {
						self.sceneView.scene.rootNode.addChildNode(dummyScene.rootNode)
						print("added scene")
					}
                }
				
                node.simdTransform = imageAnchor.transform
                
                let angle = node.eulerAngles
                node.eulerAngles = SCNVector3(angle.x - (Float.pi * 0.5), angle.y, angle.z)
                
            }
            
        }
        
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
