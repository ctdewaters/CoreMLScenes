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
        
        var buffer: CVPixelBuffer!
        
        var rect = NSRect(x: 0, y: 0, width: 224, height: 224)
        let cgImage = self.imageView.image?.cgImage(forProposedRect: &rect, context: nil, hints: nil)
        
        self.imageView.image = NSImage(cgImage: cgImage!, size: NSSize(width: 224, height: 224))
        
        buffer = getCVPixelBuffer(cgImage!)
        let input = GoogLeNetPlacesInput(sceneImage: buffer!)
        do {
            let result = try gnetPlaces.prediction(input: input)
            self.label.stringValue = result.sceneLabel
            print("Result is \(result.sceneLabel)")
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getCVPixelBuffer(_ image: CGImage) -> CVPixelBuffer? {
        let imageWidth = 224//Int(image.width)
        let imageHeight = 224//Int(image.height)
        
        let attributes : [NSObject:AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject
        ]
        
        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            imageWidth,
                            imageHeight,
                            kCVPixelFormatType_32ARGB,
                            attributes as CFDictionary?,
                            &pxbuffer)
        
        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            let context = CGContext(data: pxdata,
                                    width: imageWidth,
                                    height: imageHeight,
                                    bitsPerComponent: 8,
                                    bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                                    space: rgbColorSpace,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
            
            if let _context = context {
                _context.draw(image, in: CGRect.init(x: 0, y: 0, width: imageWidth, height: imageHeight))
            }
            else {
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
                return nil
            }
            
            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
            return _pxbuffer;
        }
        return nil
    }}

