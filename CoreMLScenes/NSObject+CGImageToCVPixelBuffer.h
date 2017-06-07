//
//  NSObject+CGImageToCVPixelBuffer.h
//  CoreMLScenes
//
//  Created by Collin DeWaters on 6/7/17.
//  Copyright © 2017 Collin DeWaters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

@interface NSObject (CGImageToCVPixelBuffer)

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image;

@end
