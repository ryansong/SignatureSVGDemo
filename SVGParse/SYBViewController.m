//
//  SYBViewController.m
//  SVGParse
//
//  Created by Song Xiaoming on 4/7/14.
//  Copyright (c) 2014 Song Xiaoming. All rights reserved.
//

#import "SYBViewController.h"
#import "SYBSignatureView.h"

@interface SYBViewController ()

@property (nonatomic, strong)SYBSignatureView *signView;

@end

@implementation SYBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _signView = [[SYBSignatureView alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
    _signView.backgroundColor = [UIColor clearColor];
    _signView.center = self.view.center;
    [self.view addSubview:_signView];
    _signView.layer.borderColor = [[UIColor blackColor] CGColor];
    _signView.layer.borderWidth = 1.0f;
    
    UIButton *clean = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, 240, 40)];
    [clean setTitle:@"clean" forState:UIControlStateNormal];
    [clean setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clean addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clean];
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 240, 40)];
    [save setTitle:@"save" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
}

- (void)cancel
{
    [_signView earseSignature];
}

- (void)save
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *filePath = [path stringByAppendingString:@"demo.svg"];
    
    //get svg file
    NSData *svgfile = [_signView getSvgFile];
    NSError *error;
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    [svgfile writeToFile:filePath options:NSDataWritingAtomic error: &error];
    
    if (error) {
        NSLog(@"save %@ has error %@", filePath, error);
    } else {
        NSLog(@"the svg file has saved as %@ ", filePath);
    }
}
@end
