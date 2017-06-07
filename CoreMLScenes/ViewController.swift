//
//  ViewController.swift
//  CoreMLScenes
//
//  Created by Collin DeWaters on 6/6/17.
//  Copyright © 2017 Collin DeWaters. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var chooseImage: NSButton!
    @IBAction func chooseImage(_ sender: Any) {
        openPanel()
    }
    
    func openPanel() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel .allowsMultipleSelection = false
        let clicked = panel.runModal()
        if clicked == .OK {
            if let url = panel.url {
                let image = NSImage(contentsOf: url)
                self.imageView.image = image
                processImage()
            }
        }
    }
    
    func processImage() {
        let gnetPlaces = GoogLeNetPlaces()
        
        var buffer = CVPixelBuffer()
        
        let ciImage = CIImage(data: self.imageView.image!.tiffRepresentation!)
        let context = CIContext()
        context.render(ciImage!, to: buffer)
        
        let input = GoogLeNetPlacesInput(sceneImage: buffer)
        do {
            let result = try gnetPlaces.prediction(input: input)
            self.label.stringValue = result.sceneLabel
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

