//
//  SYBSignatureView.m
//  signatureDemo
//
//  Created by Song Xiaoming on 4/2/14.
//  Copyright (c) 2014 InsigmaHengtian software Ltd. All rights reserved.
//

#import "SYBSignatureView.h"
#import "SYBSVGXMLDoc.h"

@interface SYBSignatureView()
{
 @private
    CGPoint previousPoint;
}

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *paths;

@property (nonatomic, strong) SYBSVGXMLDoc *doc;

@end

@implementation SYBSignatureView

static CGPoint midpoint(CGPoint p0, CGPoint p1)
{
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _paths = [[NSMutableArray alloc] init];
        _path = [UIBezierPath bezierPath];
        
        // default value for stoke
        _strokeColor = [UIColor blackColor];
        _strokeWidth = 1.0f;
        
        // Capture touches
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint middlePoint = midpoint(previousPoint, currentPoint);
    
    if (!_paths) {
        _paths = [[NSMutableArray alloc] init];
    }
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (!_path) {
            _path = [UIBezierPath bezierPath];
        }
        [_path moveToPoint:currentPoint];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [_path addQuadCurveToPoint:middlePoint controlPoint:previousPoint];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        [_path addQuadCurveToPoint:middlePoint controlPoint:previousPoint];
        [_paths addObject:[_path copy]];
        _path = nil;
        NSLog(@"pan ends");
    }
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    //Clean the view
    if (!_paths) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, self.bounds);
    }
    
    [_strokeColor setStroke];
    [_path setLineWidth:_strokeWidth];

    for (UIBezierPath *bezierPath in _paths) {
        [bezierPath stroke];
    }
    
    [_path stroke];
}

- (void)earseSignature
{
    _path = nil;
    _paths = nil;
    [self setNeedsDisplay];
}

- (NSData *)getSvgFile
{
   [self svgFromBezier];
    return _svgData;
}

- (void)svgFromBezier
{
    if (!_paths || [_paths count] < 1) {
        _svgData = nil;
        return;
    }
    _doc = [[SYBSVGXMLDoc alloc] initSVGXMLWithImageSize:self.frame.size];
    _svgData = [NSData dataWithData:[_doc svgByBesizerPaths:_paths]];
}
@end
