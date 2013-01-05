//
//  MosaicViewDelegateProtocol.h
//  MosaicUI
//
//  Created by Ezequiel A Becerra on 11/25/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MosaicDataView;

@protocol MosaicViewDelegateProtocol <NSObject>

-(void)mosaicViewDidTap:(MosaicDataView *)aModule;
-(void)mosaicViewDidDoubleTap:(MosaicDataView *)aModule;

@end
