//
//  DependencyContainerTest.m
//  pcv
//
//  Created by Antoine d'Otreppe on 08/14/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "APServiceBoxTest.h"
#import "APServiceBox.h"
#import "Injectable.h"
#import "InjectableSubclass.h"

@implementation APServiceBoxTest {
    APServiceBox *_box;
}

- (void)setUp
{
    _box = [[APServiceBox alloc] init];
}

- (void)testInjectsBasedOnTypeAndName
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"manual"];
    [_box fill:injectable];

    STAssertEquals(injectable, injectable.manual, @"Must be the same object");
}

- (void)testWorksOnSynthesizedProperties
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"synthesized"];
    [_box fill:injectable];

    STAssertEquals(injectable, injectable.synthesized, @"Must be the same object");
}

- (void)testFiltersByName
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"non existing property name"];
    [_box fill:injectable];

    STAssertNil(injectable.synthesized, @"Nothing must have been injected");
    STAssertNil(injectable.manual, @"Nothing must have been injected");
}

- (void)testSkipsReadonlyProperties
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"readonly"];
    [_box fill:injectable];

    STAssertNil(injectable.readonly, @"Nothing must have been injected");
}

- (void)testInjectsItselfIfPossible
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box fill:injectable];
    
    STAssertEquals(_box, injectable.serviceBox, @"The dependency container must inject itself as 'serviceBox'");
    NSLocalizedString(@"ie", @"ie");
}

- (void)testInjectsBasedOnProtocol
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"proto"];
    [_box fill:injectable];

    STAssertEquals(injectable, injectable.proto, @"id<protocol> must be injected as well.");
}

- (void)testInjectsPropertiesFromSuperclasses
{
    InjectableSubclass *injected = [[InjectableSubclass alloc] init];
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"synthesized"];
    [_box fill:injected];
    
    STAssertEquals(injectable, injected.synthesized, @"The injection must work with properties from superclasses.");
}

- (void)testInjectsBasedOnSuperclass
{
    InjectableSubclass *injectable = [[InjectableSubclass alloc] init];
    [_box registerDependency:injectable as:@"synthesized"];
    [_box fill:injectable];

    STAssertEquals(injectable, injectable.synthesized, @"The injection must work with superclasses.");
}

@end
