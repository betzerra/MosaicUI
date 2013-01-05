//
//  OverlayImageView.m
//  Mosaic
//
//  Created by Ezequiel A Becerra on 12/10/12.
//  Copyright (c) 2012 Betzerra. All rights reserved.
//

#import "OverlayImageView.h"

@implementation OverlayImageView
@synthesize image;
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float scale = 1;
    
    if (self.image.size.width < self.image.size.height){
        scale = self.frame.size.width / self.image.size.width;
    }else{
        scale = self.frame.size.height / self.image.size.height;
    }
    
    CGSize imageScaledSize = CGSizeMake(self.image.size.width * scale, self.image.size.height * scale);
    CGRect imageFrame = CGRectMake(self.frame.size.width/2 - imageScaledSize.width/2,
                                   self.frame.size.height/2 - imageScaledSize.height/2,
                                   imageScaledSize.width,
                                   imageScaledSize.height);
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0.0f, imageFrame.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    // Draw picture first
    CGContextDrawImage(context, imageFrame, image.CGImage);
    
    CGContextRestoreGState(context);
    
    // Blend mode could be any of CGBlendMode values. Now draw filled rectangle
    // over top of image.
    CGContextSetBlendMode (context, kCGBlendModeMultiply);
    CGContextSetFillColor(context, CGColorGetComponents(overlayColor.CGColor));
    CGContextFillRect (context, self.bounds);
}

-(void)setOverlayColor:(UIColor *)newOverlayColor{
    overlayColor = newOverlayColor;
}

-(UIColor *)overlayColor{
    return overlayColor;
}


@end
