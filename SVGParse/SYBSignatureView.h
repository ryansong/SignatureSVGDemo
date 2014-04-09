//
//  SYBSignatureView.h
//  signatureDemo
//
//  Created by Song Xiaoming on 4/2/14.
//  Copyright (c) 2014 InsigmaHengtian software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYBSignatureView : UIView

@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) NSData *svgData;

- (void)earseSignature;
- (NSData *)getSvgFile;
@end
