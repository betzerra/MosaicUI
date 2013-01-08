//
//  TwoDimentionalArray.h
//  MosaicUI
//
//  Created by Ezequiel A Becerra on 11/24/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoDimentionalArray : NSObject{
    NSMutableArray* elements;
    NSUInteger rows, columns;
}

-(id)initWithColumns:(NSUInteger)numberOfColumns andRows:(NSUInteger)numberOfRows;
-(id)objectAtColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex;
-(void)setObject:(id)anObject atColumn:(NSUInteger)xIndex andRow:(NSUInteger)yIndex;

@end
