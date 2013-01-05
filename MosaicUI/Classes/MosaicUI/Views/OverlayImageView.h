//
//  OverlayImageView.h
//  Mosaic
//
//  Created by Ezequiel A Becerra on 12/10/12.
//  Copyright (c) 2012 Betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayImageView : UIView{
    UIColor *overlayColor;
}

@property (strong) UIColor *overlayColor;
@property (strong) UIImage *image;

@end
