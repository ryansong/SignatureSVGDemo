//
//  SYBSVGXMLDoc.h
//  SVGParse
//
//  Created by Song Xiaoming on 4/8/14.
//  Copyright (c) 2014 InsigmaHengtian software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYBSVGXMLDoc : NSObject

@property (nonatomic, readonly) NSString *xmlStatement;
@property (nonatomic, readonly) NSString *svgElement;

@property (nonatomic, strong) NSData *svgFile;

- (id)initSVGXMLWithImageSize:(CGSize) imageSize;
- (NSData *) svgByBesizerPaths:(NSArray *)paths;
@end
