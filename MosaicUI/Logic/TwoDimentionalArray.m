//
//  TwoDimentionalArray.m
//  MosaicUI
//
//  Created by Ezequiel A Becerra on 11/24/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "TwoDimentionalArray.h"

#define INVALID_ELEMENT_INDEX -1

@implementation TwoDimentionalArray

#pragma mark - Private

-(NSInteger)elementIndexWithColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex{
    NSInteger retVal = 0;

    // Validating indexes are between columns / rows ranges
    if (xIndex >= columns || yIndex >= rows){
        retVal = INVALID_ELEMENT_INDEX;
    }else{
        retVal = xIndex + (yIndex * columns);
    }
    return retVal;
}

#pragma mark - Public

-(id)initWithColumns:(NSUInteger)numberOfColumns andRows:(NSUInteger)numberOfRows{
    self = [super init];
    if (self){
        NSUInteger capacity = numberOfColumns * numberOfRows;
        columns = numberOfColumns;
        rows = numberOfRows;
        elements = [[NSMutableArray alloc] initWithCapacity:capacity];
        
        for(NSInteger i=0; i<capacity; i++){
            [elements addObject:[NSNull null]];
        }
    }
    return self;
}

-(id)objectAtColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex{
    id retVal = nil;
    
    NSInteger elementIndex = [self elementIndexWithColumn:xIndex andRow:yIndex];

    //  If the index is not invalid (ie xIndex greater than column quantity) then...
    if (elementIndex != INVALID_ELEMENT_INDEX){
        
        //  If the element in coord is not NULL then...
        if ([elements objectAtIndex:elementIndex] != [NSNull null]){
            retVal = [elements objectAtIndex:elementIndex];
        }
    }

    return retVal;
}

-(void)setObject:(id)anObject atColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex{
    NSInteger elementIndex = [self elementIndexWithColumn:xIndex andRow:yIndex];
    
    [elements replaceObjectAtIndex:elementIndex withObject:anObject];
}

@end
