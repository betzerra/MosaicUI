//
//  MosaivView.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 11/26/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicView.h"
#import "MosaicData.h"
#import "MosaicDataView.h"

#define kModuleSizeInPoints_iPhone 80
#define kModuleSizeInPoints_iPad 128
#define kMaxScrollPages_iPhone 4
#define kMaxScrollPages_iPad 4

@implementation MosaicView
@synthesize datasource, delegate;

#pragma mark - Private

- (void)setup{
    _maxElementsX = -1;
    _maxElementsY = -1;
    
    //  Add scrollview and set its position and size using autolayout constraints
    scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:scrollView];    
}

- (BOOL)doesModuleWithCGSize:(CGSize)aSize fitsInCoord:(CGPoint)aPoint{
    BOOL retVal = YES;
    
    NSInteger xOffset = 0;
    NSInteger yOffset = 0;
    
    while (retVal && yOffset < aSize.height){
        xOffset = 0;
        
        while (retVal && xOffset < aSize.width){
            NSInteger xIndex = aPoint.x + xOffset;
            NSInteger yIndex = aPoint.y + yOffset;
            
            //  Check if the coords are valid in the bidimensional array
            if (xIndex < [self maxElementsX] && yIndex < [self maxElementsY]){
                
                id anObject = [elements objectAtColumn:xIndex andRow:yIndex];
                if (anObject != nil){
                    retVal = NO;
                }
                
                xOffset++;
            }else{
                retVal = NO;
            }
        }
        
        yOffset++;
    }
    
    return retVal;
}

- (void)setModule:(MosaicData *)aModule withCGSize:(CGSize)aSize withCoord:(CGPoint)aPoint{
    NSInteger xOffset = 0;
    NSInteger yOffset = 0;
    
    while (yOffset < aSize.height){
        xOffset = 0;
        
        while (xOffset < aSize.width){
            NSInteger xIndex = aPoint.x + xOffset;
            NSInteger yIndex = aPoint.y + yOffset;
            
            [elements setObject:aModule atColumn:xIndex andRow:yIndex];
            
            xOffset++;
        }
        
        yOffset++;
    }
}

- (NSArray *)coordArrayForCGSize:(CGSize)aSize{
    NSArray *retVal = nil;
    BOOL hasFound = NO;
    
    NSInteger i=0;
    NSInteger j=0;
    
    while (j < [self maxElementsY] && !hasFound){
        
        i = 0;
        
        while (i < [self maxElementsX] && !hasFound){
            
            BOOL fitsInCoord = [self doesModuleWithCGSize:aSize fitsInCoord:CGPointMake(i, j)];
            if (fitsInCoord){
                hasFound = YES;
                
                NSNumber *xIndex = [NSNumber numberWithInteger:i];
                NSNumber *yIndex = [NSNumber numberWithInteger:j];
                retVal = @[xIndex, yIndex];
            }
            
            i++;
        }
        
        j++;
    }
    
    return retVal;
}

- (CGSize)sizeForModuleSize:(NSUInteger)aSize{
    CGSize retVal = CGSizeZero;
    
    switch (aSize) {
            
        case 0:
            retVal = CGSizeMake(4, 4);
            break;
        case 1:
            retVal = CGSizeMake(2, 2);
            break;
        case 2:
            retVal = CGSizeMake(2, 1);
            break;
        case 3:
            retVal = CGSizeMake(1, 1);
            break;
            
        default:
            break;
    }
    
    return retVal;
}

- (NSInteger)moduleSizeInPoints{
    NSInteger retVal = kModuleSizeInPoints_iPhone;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        retVal = kModuleSizeInPoints_iPad;
    }
    
    return retVal;
}

- (NSInteger)maxElementsX{
    NSInteger retVal = _maxElementsX;
    
    if (retVal == -1){
        retVal = self.frame.size.width / [self moduleSizeInPoints];
    }
    
    return retVal;
}

- (NSInteger)maxElementsY{
    NSInteger retVal = _maxElementsY;
    
    if (retVal == -1){
        retVal = self.frame.size.height / [self moduleSizeInPoints] * [self maxScrollPages];
    }
    
    return retVal;
}

- (NSInteger)maxScrollPages{
    NSInteger retVal = kMaxScrollPages_iPhone;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        retVal = kMaxScrollPages_iPad;
    }
    return retVal;
}

- (void)setupLayoutWithMosaicElements:(NSArray *)mosaicElements{
    NSInteger yOffset = 0;
    
    _maxElementsX = -1;
    _maxElementsY = -1;
    
    NSInteger scrollHeight = 0;
    
    scrollView.frame = [self bounds];
    
    for (UIView *subView in scrollView.subviews){
        [subView removeFromSuperview];
    }
    
    // Initial setup for the view
    NSUInteger maxElementsX = [self maxElementsX];
    NSUInteger maxElementsY = [self maxElementsY];
    elements = [[TwoDimentionalArray alloc] initWithColumns:maxElementsX andRows:maxElementsY];    
    
    CGPoint modulePoint = CGPointZero;
    
    MosaicDataView *lastModuleView = nil;
    
    //  Set modules in scrollView
    for (MosaicData *aModule in mosaicElements){        
        CGSize aSize = [self sizeForModuleSize:aModule.size];
        NSArray *coordArray = [self coordArrayForCGSize:aSize];
        
        if (coordArray){
            NSInteger xIndex = [coordArray[0] integerValue];
            NSInteger yIndex = [coordArray[1] integerValue];
            
            modulePoint = CGPointMake(xIndex, yIndex);
            
            [self setModule:aModule withCGSize:aSize withCoord:modulePoint];
            
            CGRect mosaicModuleRect = CGRectMake(xIndex * [self moduleSizeInPoints],
                                                 yIndex * [self moduleSizeInPoints] + yOffset,
                                                 aSize.width * [self moduleSizeInPoints],
                                                 aSize.height * [self moduleSizeInPoints]);
                        
            lastModuleView = [[MosaicDataView alloc] initWithFrame:mosaicModuleRect];
            lastModuleView.module = aModule;
            lastModuleView.mosaicView = self;
            
            [scrollView addSubview:lastModuleView];
            
            scrollHeight = MAX(scrollHeight, lastModuleView.frame.origin.y + lastModuleView.frame.size.height);
        }
    }
    
    //  Setup content size
    CGSize contentSize = CGSizeMake(scrollView.frame.size.width,scrollHeight);
    scrollView.contentSize = contentSize;    
}

#pragma mark - Public

- (id)init{
    self = [super init];
    if (self){
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)refresh{
    NSArray *mosaicElements = [self.datasource mosaicElements];
    [self setupLayoutWithMosaicElements:mosaicElements];
}

- (void)layoutSubviews{
    [self refresh];
    [super layoutSubviews];
}

@end
