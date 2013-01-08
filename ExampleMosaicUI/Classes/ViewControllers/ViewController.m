//
//  ViewController.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "ViewController.h"
#import "MosaicData.h"
#import "MosaicDataView.h"
#import "CustomMosaicDatasource.h"

@implementation ViewController

#pragma mark - Public

- (void)viewDidLayoutSubviews{
}

- (void)viewDidLoad{
    [super viewDidLoad];
    mosaicView.datasource = [CustomMosaicDatasource sharedInstance];
    mosaicView.delegate = self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MosaicViewDelegateProtocol

-(void)mosaicViewDidTap:(MosaicDataView *)aModule{
    NSLog(@"#DEBUG Tapped %@", aModule.module);
}

-(void)mosaicViewDidDoubleTap:(MosaicDataView *)aModule{
    NSLog(@"#DEBUG Double Tapped %@", aModule.module);
}

@end
