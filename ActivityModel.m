//
//  ActivityModel.m
//  Orienteering
//
//  Created by macmini on 15/4/17.
//  Copyright (c) 2015年 GY. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    ActivityModel* copy = [[[self class]allocWithZone:zone]init];
    copy.stadiumName = [_stadiumName copyWithZone:zone];
    copy.mapType = [_mapType copyWithZone:zone];
    return copy;
}

#pragma mark  NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stadiumName forKey:@"stadiumName"];
    [aCoder encodeObject:_mapType forKey:@"mapType"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    _stadiumName = [aDecoder decodeObjectForKey:@"stadiumName"];
    _mapType = [aDecoder decodeObjectForKey:@"mapType"];
    return self;
}

-(instancetype)initWithStadiums :(NSString*)stadiumName mapType:(NSString*)mapTypeString
{
    self = [super init];
    if (self) {
        self.stadiumName = stadiumName;
        self.mapType = mapTypeString;
    }
    return self;
}

@end
