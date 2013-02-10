//
//  MosaivView.h
//  MosaicUI
//
//  Created by Ezequiel Becerra on 11/26/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "TwoDimentionalArray.h"

#import "MosaicViewDatasourceProtocol.h"
#import "MosaicViewDelegateProtocol.h"
#import "MosaicDataView.h"

@interface MosaicView : UIView{
    TwoDimentionalArray *elements;
    UIScrollView *scrollView;
    
    NSInteger _maxElementsX;
    NSInteger _maxElementsY;
}

@property (weak) id <MosaicViewDatasourceProtocol> datasource;
@property (weak) id <MosaicViewDelegateProtocol> delegate;
@property (strong) MosaicDataView *selectedDataView;

-(void) refresh;

@end
