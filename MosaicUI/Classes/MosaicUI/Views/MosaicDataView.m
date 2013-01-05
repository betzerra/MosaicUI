//
//  MosaicModuleView.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicDataView.h"
#import "MosaicView.h"
#define kMosaicDataViewDidTouchNotification @"kMosaicDataViewDidTouchNotification"
#define kMosaicDataViewFont @"Helvetica-Bold"

@implementation MosaicDataView
@synthesize delegate, mosaicView;

#pragma mark - Private

-(UIFont *)fontWithModuleSize:(NSUInteger)aSize{

    UIFont *retVal = nil;
    
    switch (aSize) {
        case 0:
            retVal = [UIFont fontWithName:kMosaicDataViewFont size:36];
            break;
        case 1:
            retVal = [UIFont fontWithName:kMosaicDataViewFont size:18];
            break;
        case 2:
            retVal = [UIFont fontWithName:kMosaicDataViewFont size:15];
            break;
        default:
            retVal = [UIFont fontWithName:kMosaicDataViewFont size:15];
            break;
    }
    
    return retVal;
}

-(void)mosaicViewDidTouch:(NSNotification *)aNotification{
    MosaicDataView *aView = [aNotification.userInfo objectForKey:@"mosaicDataView"];
    if (aView != self){
    }
}

#pragma mark - Properties

-(NSString *)title{
    NSString *retVal = titleLabel.text;
    return retVal;
}

-(void)setTitle:(NSString *)title{
    titleLabel.text = title;
}

-(void)setModule:(MosaicData *)newModule{
    module = newModule;
    
    UIImage *anImage = [UIImage imageNamed:self.module.imageFilename];
    imageView.image = anImage;
    
    float scale = 1;
    
    if (anImage.size.width < anImage.size.height){
        scale = anImage.size.width / anImage.size.height;
    }else{
        scale = anImage.size.height / anImage.size.width;
    }
    
    CGRect newFrame = imageView.frame;
    newFrame.size.height /= scale;
    newFrame.size.width /= scale;
    imageView.frame = newFrame;
    imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //  Set new title
    NSInteger marginLeft = self.frame.size.width / 20;
    NSInteger marginBottom = self.frame.size.height / 20;
    
    titleLabel.text = module.title;
    titleLabel.font = [self fontWithModuleSize:module.size];
    
    CGSize newSize = [module.title sizeWithFont:titleLabel.font constrainedToSize:titleLabel.frame.size];
    CGRect newRect = CGRectMake(marginLeft,
                                self.frame.size.height - newSize.height - marginBottom,
                                newSize.width,
                                newSize.height);
    titleLabel.frame = newRect;
}

-(MosaicData *)module{
    return module;
}

-(void)displayHighlightAnimation{
    if (self.mosaicView.selectedDataView != self){
        // Notify to the rest of MosaicDataView to show the overlayView again
        NSDictionary *aDict = @{@"mosaicDataView" : self};
        [[NSNotificationCenter defaultCenter] postNotificationName:kMosaicDataViewDidTouchNotification
                                                            object:nil
                                                          userInfo:aDict];
        
        self.alpha = 0.3;
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL completed){
                             // Do nothing. This is only visual feedback.
                             // See simpleExclusiveTapRecognized instead
                         }];
    }
}

-(void)simpleTapReceived:(id)sender{
    if ([delegate respondsToSelector:@selector(mosaicViewDidTap:)]){
        [delegate mosaicViewDidTap:self];
    }
    self.mosaicView.selectedDataView = self;    
}

-(void)doubleTapReceived:(id)sender{
    if ([delegate respondsToSelector:@selector(mosaicViewDidDoubleTap:)]){
        [delegate mosaicViewDidDoubleTap:self];        
    }
}

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        //  UIImageView on background
        CGRect imageViewFrame = CGRectMake(0,0,frame.size.width,frame.size.height);
        imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        //  UILabel for title
        CGRect titleLabelFrame = CGRectMake(0,
                                       round(frame.size.height/2),
                                       frame.size.width,
                                       round(frame.size.height/2));
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:kMosaicDataViewFont size:15];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        titleLabel.numberOfLines = 1;
        [self addSubview:titleLabel];

        //  Set stroke width
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.clipsToBounds = YES;
        
        //  Subscribe to a Notification so can unhighlight when user taps other MosaicDataViews
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mosaicViewDidTouch:)
                                                     name:kMosaicDataViewDidTouchNotification
                                                   object:nil];
        
        //  Add double tap recognizer
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(doubleTapReceived:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        //  Add simple tap recognizer. This will get call ONLY if the double tap fails, so it's got a little delay
        UITapGestureRecognizer *simpleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(simpleTapReceived:)];
        simpleTapRecognizer.numberOfTapsRequired = 1;
        [simpleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        simpleTapRecognizer.delegate = self;
        [self addGestureRecognizer:simpleTapRecognizer];
    }
    return self;
}

-(void)removeFromSuperview{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //  Display the animation no matter if the gesture fails or not
    BOOL retVal = [super gestureRecognizerShouldBegin:gestureRecognizer];
    [self displayHighlightAnimation];
    return retVal;
}

-(void)removeFromSuperview{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

@end
