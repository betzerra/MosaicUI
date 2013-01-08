//
//  MosaicManager.h
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/23/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MosaicViewDatasourceProtocol.h"

@interface CustomMosaicDatasource : NSObject <MosaicViewDatasourceProtocol>{
    NSMutableArray *elements;
}

+ (CustomMosaicDatasource *)sharedInstance;

@end
