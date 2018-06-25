//
//  ViewController.swift
//  armon
//
//  Created by Alexandre Brispot on 25/06/2018.
//  Copyright © 2018 Alexandre Brispot. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 15
    let waitDuration: TimeInterval = 0.5
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([.fadeIn(duration: fadeDuration)])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        sceneView.showsStatistics = true
        #endif

        sceneView.delegate = self
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    private func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "cards", bundle: nil) else {
            return
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.isAutoFocusEnabled = true
		
        if #available(iOS 12.0, *) {
            configuration.maximumNumberOfTrackedImages = 6
        }

        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }

    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    
    func getSubNodes(in scene: SCNScene) -> [SCNNode] {
        var nodes: [SCNNode] = [SCNNode]()
        for node in scene.rootNode.childNodes {
            nodes.append(node)
        }
        return nodes
    }
    
    func getNode(withImageName name: String) -> SCNNode {
        guard let scene = SCNScene(named: "\(name).scnassets/\(name).dae") else {
            return SCNNode()
        }
        let nodes = getSubNodes(in: scene)
        let render = SCNNode()
        for node in nodes {
            render.addChildNode(node)
        }
        
        var scaleFactor: Float = 1
        
        switch name {
        case "Bulbasaur":
            scaleFactor = 0.001
        case "Eevee":
            scaleFactor = 0.003
        default:
            scaleFactor = 1
        }
        
        render.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        render.position.y = render.position.y * scaleFactor
        
        return render
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        let referenceImage = imageAnchor.referenceImage
        let imageName = referenceImage.name ?? "no name"
		
        let overlayNode = getNode(withImageName: imageName)
        overlayNode.opacity = 0
        overlayNode.runAction(self.fadeAndSpinAction)

        node.addChildNode(overlayNode)
    }
}
