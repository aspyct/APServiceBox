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
#import "Target.h"
#import "SelfFilling.h"

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

    XCTAssertEqual(injectable, injectable.manual, @"Must be the same object");
}

- (void)testWorksOnSynthesizedProperties
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"synthesized"];
    [_box fill:injectable];

    XCTAssertEqual(injectable, injectable.synthesized, @"Must be the same object");
}

- (void)testFiltersByName
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"non existing property name"];
    [_box fill:injectable];

    XCTAssertNil(injectable.synthesized, @"Nothing must have been injected");
    XCTAssertNil(injectable.manual, @"Nothing must have been injected");
}

- (void)testInjectsItselfIfPossible
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box fill:injectable];
    
    XCTAssertEqual(_box, injectable.serviceBox, @"The dependency container must inject itself as 'serviceBox'");
    NSLocalizedString(@"ie", @"ie");
}

- (void)testInjectsBasedOnProtocol
{
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"proto"];
    [_box fill:injectable];

    XCTAssertEqual(injectable, injectable.proto, @"id<protocol> must be injected as well.");
}

- (void)testInjectsPropertiesFromSuperclasses
{
    InjectableSubclass *injected = [[InjectableSubclass alloc] init];
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:injectable as:@"synthesized"];
    [_box fill:injected];
    
    XCTAssertEqual(injectable, injected.synthesized, @"The injection must work with properties from superclasses.");
}

- (void)testInjectsBasedOnSuperclass
{
    InjectableSubclass *injectable = [[InjectableSubclass alloc] init];
    [_box registerDependency:injectable as:@"synthesized"];
    [_box fill:injectable];

    XCTAssertEqual(injectable, injectable.synthesized, @"The injection must work with superclasses.");
}

- (void)testAlsoFillsDependencies
{
    Target *target = [[Target alloc] init];
    Injectable *injectable = [[Injectable alloc] init];
    [_box registerDependency:target as:@"nothing"];
    [_box registerDependency:injectable as:@"injectable"];
    
    [_box fill:injectable];
    XCTAssertNotNil(target.injectable, @"Must inject the dependencies into each other");
}

- (void)testObjectCanRequestInjection
{
    [[APServiceBox defaultBox] registerDependency:[[Injectable alloc] init] as:@"injectable"];
    SelfFilling *filling = [[SelfFilling alloc] init];
    
    XCTAssertNotNil(filling.injectable, @"Must self-inject dependencies");
}

@end
