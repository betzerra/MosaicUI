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
            retVal = [UIFont fontWithName:kMosaicDataViewFont size:18];
            break;
        case 3:
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
        //  This gets called when another MosaicDataView gets selected
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
    
    CGSize imgFinalSize = CGSizeZero;

    if (anImage.size.width < anImage.size.height){
        imgFinalSize.width = self.bounds.size.width;
        imgFinalSize.height = self.bounds.size.width * anImage.size.height / anImage.size.width;
        
        //  This is to avoid black bars on the bottom and top of the image
        //  Happens when images have its height lesser than its bounds
        if (imgFinalSize.height < self.bounds.size.height){
            imgFinalSize.width = self.bounds.size.height * self.bounds.size.width / imgFinalSize.height;
            imgFinalSize.height = self.bounds.size.height;
        }
    }else{
        imgFinalSize.height = self.bounds.size.height;
        imgFinalSize.width = self.bounds.size.height * anImage.size.width / anImage.size.height;
        
        //  This is to avoid black bars on the left and right of the image
        //  Happens when images have its width lesser than its bounds
        if (imgFinalSize.width < self.bounds.size.width){
            imgFinalSize.height = self.bounds.size.height * self.bounds.size.width / imgFinalSize.height;
            imgFinalSize.width = self.bounds.size.width;
        }
    }
    
//    NSLog(@"#DEBUG imageRect %.2f %.2f (%.2f %.2f) %@", imgFinalSize.width, imgFinalSize.height, anImage.size.width, anImage.size.height, newModule);
    
    imageView.frame = CGRectMake(0, 0, imgFinalSize.width, imgFinalSize.height);
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
        //  Notify to the rest of MosaicDataView which is the selected MosaicDataView
        //  (Usefull is you need to deselect some MosaicDataView)
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
    BOOL retVal = YES;
    
    /*  From http://developer.apple.com NSObject class reference
     *  You cannot test whether an object inherits a method from its superclass by sending respondsToSelector:
     *  to the object using the super keyword. This method will still be testing the object as a whole, not just 
     *  the superclass’s implementation. Therefore, sending respondsToSelector: to super is equivalent to sending 
     *  it to self. Instead, you must invoke the NSObject class method instancesRespondToSelector: directly on 
     *  the object’s superclass */
    
    SEL aSel = @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    
    /*  You cannot simply use [[self superclass] instancesRespondToSelector:@selector(aMethod)] 
     *  since this may cause the method to fail if it is invoked by a subclass. */
    
    if ([UIView instancesRespondToSelector:aSel]){
        retVal = [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
    [self displayHighlightAnimation];
    return retVal;
}

@end
