//
//  ViewController.h
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicView.h"
#import "MosaicViewDelegateProtocol.h"

@interface ViewController : UIViewController <MosaicViewDelegateProtocol>{
    __weak IBOutlet MosaicView *mosaicView;
    UIImageView *snapshotBeforeRotation;
    UIImageView *snapshotAfterRotation;
}

@end
