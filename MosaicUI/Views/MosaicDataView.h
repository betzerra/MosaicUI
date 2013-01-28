//
//  MosaicModuleView.h
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MosaicData.h"
#import "MosaicViewDelegateProtocol.h"
@class MosaicView;

@interface MosaicDataView : UIView <UIGestureRecognizerDelegate>{
    UIImageView *imageView;
    UILabel *titleLabel;
    MosaicData *module;
}

@property (strong) NSString *title;
@property (strong) MosaicData *module;
@property (weak) MosaicView *mosaicView;

@end
