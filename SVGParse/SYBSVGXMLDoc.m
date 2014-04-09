//
//  SYBSVGXMLDoc.m
//  SVGParse
//
//  Created by Song Xiaoming on 4/8/14.
//  Copyright (c) 2014 InsigmaHengtian software Ltd. All rights reserved.
//

#import "SYBSVGXMLDoc.h"

static NSMutableString *svgPath;

static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

void MyCGPathApplierFunc(void *info, const CGPathElement *element)
{
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;

    CGPoint currentPoint;
    CGPoint preventPoint;
    CGPoint middlePoint;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch (type) {
        case kCGPathElementAddQuadCurveToPoint:
            currentPoint = points[0];
            middlePoint = midpoint(preventPoint, currentPoint);
            [svgPath appendFormat:@"\nQ%f %f %f %f", preventPoint.x, preventPoint.y, middlePoint.x, middlePoint.y];
            [bezierPoints addObject:[NSValue valueWithCGPoint:currentPoint]];
            preventPoint = currentPoint;
            break;
        case kCGPathElementMoveToPoint:
            currentPoint = points[0];
            [svgPath appendFormat:@"M%f %f", currentPoint.x, currentPoint.y];
            [bezierPoints addObject:[NSValue valueWithCGPoint:currentPoint]];
            preventPoint = currentPoint;
            break;
        case kCGPathElementCloseSubpath:
            currentPoint = points[0];
            middlePoint = midpoint(preventPoint, currentPoint);
            [svgPath appendFormat:@"\nQ%f %f %f %f", preventPoint.x, preventPoint.y, middlePoint.x, middlePoint.y];
            [bezierPoints addObject:[NSValue valueWithCGPoint:currentPoint]];
            preventPoint = currentPoint;
            break;
        default:
            break;
    }
}

@implementation SYBSVGXMLDoc

- (id)initSVGXMLWithImageSize:(CGSize)imageSize
{
    self = [super init];
    if (self) {
        _xmlStatement = @"<?xml version=\"1.0\"?>";
        _svgElement = [NSString stringWithFormat:@"<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" height=\"%f\" width =\"%f\">\n",imageSize.width, imageSize.height];
    }
    return self;
}

- (NSData *) svgByBesizerPaths:(NSArray *)paths
{
    NSMutableString *svgFileString = [[NSMutableString alloc] init];
    [svgFileString appendString:_xmlStatement];
    [svgFileString appendString:_svgElement];
    
    for (UIBezierPath *path in paths){
        CGFloat stokeWidth = 1.0;
        
        CGPathRef cgPath = path.CGPath;
        NSMutableArray *bezierPoints = [NSMutableArray array];

        svgPath = [NSMutableString stringWithString:@"<path d=\""];
       
        CGPathApply(cgPath, (__bridge void *)(bezierPoints), MyCGPathApplierFunc);
        
        [svgPath appendFormat:@"\" stroke=\"black\" stroke-width=\"%f\" fill=\"none\"/>\n\n", stokeWidth];
        [svgFileString appendString:svgPath];
    }
    [svgFileString appendString:@"\n</svg>"];
    
    _svgFile = [svgFileString dataUsingEncoding:NSUTF8StringEncoding];
    return _svgFile;
}
@end
