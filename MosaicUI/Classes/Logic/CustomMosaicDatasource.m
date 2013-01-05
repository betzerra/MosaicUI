//
//  MosaicManager.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/23/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "CustomMosaicDatasource.h"
#import "MosaicData.h"

@implementation CustomMosaicDatasource

#pragma mark - Private

-(void)loadFromDisk{
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *elementsData = [NSData dataWithContentsOfFile:pathString];

    NSError *anError = nil;
    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&anError];
    
    for (NSDictionary *aModuleDict in parsedElements){
        MosaicData *aMosaicModule = [[MosaicData alloc] initWithDictionary:aModuleDict];
        [elements addObject:aMosaicModule];
    }
}

#pragma mark - Public

-(id)init{
    self = [super init];

    if (self){
        elements = [[NSMutableArray alloc] init];
        [self loadFromDisk];
    }
    
    return self;
}

//  Singleton method proposed in WWDC 2012
+ (CustomMosaicDatasource *)sharedInstance {
	static CustomMosaicDatasource *sharedInstance;
	if (sharedInstance == nil)
		sharedInstance = [CustomMosaicDatasource new];
	return sharedInstance;
}

#pragma mark - MosaicViewDatasourceProtocol

-(NSArray *)mosaicElements{
    NSArray *retVal = elements;
    return retVal;
}

@end
