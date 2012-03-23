//
//  ARWhereStatement.m
//  iActiveRecord
//
//  Created by Alex Denisov on 23.03.12.
//  Copyright (c) 2012 CoreInvader. All rights reserved.
//

#import "ARWhereStatement.h"

@implementation ARWhereStatement

- (id)initWithStatement:(NSString *)aStatement {
    self = [super init];
    if(nil != self){
        statement = [aStatement copy];
    }
    return self;
}

- (void)dealloc {
    [statement release];
    [super dealloc];
}

+ (ARWhereStatement *)whereField:(NSString *)aField equalToValue:(id)aValue {
    NSString *stmt = [NSString stringWithFormat:
                      @" %@ = %@ ",
                      aField,
                      [aValue performSelector:@selector(toSql)]];
    return [[[ARWhereStatement alloc] initWithStatement:stmt] autorelease];
}

+ (ARWhereStatement *)whereField:(NSString *)aField notEqualToValue:(id)aValue {
    NSString *stmt = [NSString stringWithFormat:
                      @" %@ <> %@ ",
                      aField,
                      [aValue performSelector:@selector(toSql)]];
    return [[[ARWhereStatement alloc] initWithStatement:stmt] autorelease];
}

+ (ARWhereStatement *)whereField:(NSString *)aField in:(NSArray *)aValues {
    NSMutableArray *sqlValues = [NSMutableArray arrayWithCapacity:aValues.count];
    for(id value in aValues){
        [sqlValues addObject:[value performSelector:@selector(toSql)]];
    }
    NSString *values = [sqlValues componentsJoinedByString:@" , "];
    NSString *stmt = [NSString stringWithFormat:@" %@ IN (%@)", aField, values];
    return [[[ARWhereStatement alloc] initWithStatement:stmt] autorelease];
}

+ (ARWhereStatement *)whereField:(NSString *)aField notIn:(NSArray *)aValues {
    NSMutableArray *sqlValues = [NSMutableArray arrayWithCapacity:aValues.count];
    for(id value in aValues){
        [sqlValues addObject:[value performSelector:@selector(toSql)]];
    }
    NSString *values = [sqlValues componentsJoinedByString:@" , "];
    NSString *stmt = [NSString stringWithFormat:@" %@ NOT IN (%@)", aField, values];
    return [[[ARWhereStatement alloc] initWithStatement:stmt] autorelease];
}

+ (ARWhereStatement *)concatenateStatement:(ARWhereStatement *)aFirstStatement 
                                   withStatement:(ARWhereStatement *)aSecondStatement
                             useLogicalOperation:(ARLogicalOperation)logicalOperation
{
    NSString *logic = logicalOperation == ARLogicalOr ? @"OR" : @"AND";
    NSString *stmt = [NSString stringWithFormat:
                      @" ( %@ ) %@ ( %@ ) ", 
                      [aFirstStatement statement],
                      logic,
                      [aSecondStatement statement]];
    return [[[ARWhereStatement alloc] initWithStatement:stmt] autorelease];
}

- (NSString *)statement {
    return statement;
}


@end

