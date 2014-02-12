[![Stories in Ready](https://badge.waffle.io/aspyct/apservicebox.png?label=ready)](https://waffle.io/aspyct/apservicebox)
APServiceBox
============

How to use
----------

Quick & easy way: drag the two files "[APServiceBox.m](https://github.com/aspyct/APServiceBox/blob/master/APServiceBox/APServiceBox.m)" and "[APServiceBox.h](https://github.com/aspyct/APServiceBox/blob/master/APServiceBox/APServiceBox.h)" into your project.

The nice way: you tell me...

Use it when...
--------------

Use this box when you have services or objects that must be available throughout the application.
For example, if all your *ViewControllers need to report analytics, or depend on a single data source.

Usage example
-------------

The first thing you should do is register your services and other dependencies into the default service box.

```objective-c
AnalyticsManager *analyticsManager = [[AnalyticsManager alloc] init];
[[APServiceBox defaultBox] registerDependency:analyticsManager as:@"analyticsManager"];

// Or you can create your own box
APServiceBox *myBox = [[APServiceBox alloc] init];
```

**Self-injection**
The easiest way to inject dependencies is to call the `fillWithDependencies` method in the `init` of an object. This will use the default service box to fill the current object.

```objective-c
@interface MyViewController
@property (strong, nonatomic) AnalyticsService *analyticsService;
@end


#import "NSObject+APServiceBox.h"
@implementation MyViewController

- (id)init {
    self = [super init];
    
    if (self) {
        // This will ask the [APServiceBox defaultBox] to provide available dependencies
        [self fillWithDependencies];
    }
    
    return self;
}

@end

```

**Injection conditions**

There are two conditions for a dependency to be injected:

1.  the @property name corresponds to the name given when registering the service
2.  the @property type matches the registered service, that is (one of the following):
    -   service.class == @property.class
    -   [service isKindOfClass:@property.class]
    -   [service.class conformsToProtocol:@property.protocol]
    
Thus, the following two forms of properties are valid:
```objective-c
// Will match any AnalyticsService (or subclass) object
@property (...) AnalyticsService *analyticsService;

// Will match any object that conforms to <AnalyticsService> protocol
@property (...) id<AnalyticsService> *analyticsService;
```

**Inject from outside the class**

```objective-c
// Create the box
APServiceBox *box = [APServiceBox defaultBox];

// Register some services in it, here a fictive AnalyticsService object
[box registerDependency:analyticsService as:@"analyticsService"];

// Use the box to inject dependencies into object's properties
// The dependencies will be injected based on names and classes/protocols
[box fill:myViewController];

// For example, if myViewController has a property defined as follow:
@property (...) AnalyticsService *analyticsService;
// then the analyticsService from above will be injected.
```

**Inject the box itself**

If you need to inject the box itself into one of the objects (typically a UIViewController that will create other UIViewControllers), you can simply add a @property of type APServiceBox and named "serviceBox".

```objective-c
@property (strong, nonatomic) APServiceBox *serviceBox;
```

**Cross-dependency injection**

When you call `fill:` for the first time, APServiceBox will scan and fill each of the registered dependencies. This allows the following scenario:

```objective-c
@interface StorageManager

@end
```

```objective-c
@interface PreferenceManager

@property (strong, nonatomic) StorageManager *storageManager;

@end
```

```objective-c
APServiceBox *box = [[APServiceBox alloc] init];
[box registerDependency:preferenceManager as:@"preferenceManager"];
[box registerDependency:storageManager as:@"storageManager"];

// And if you invoke...
[box fill:myObject];

// ...then the following is true:
preferenceManager.storageManager == storageManager;
```

**Need more?**

If you need more insights on how this works, have a look at the [test file](https://github.com/aspyct/APServiceBox/blob/master/APServiceBoxTests/TestCases/APServiceBoxTest.m): it's short and clear!
Or contact me ;)

Contact me
----------

Name's Antoine.
-   You can reach me by mail: a.dotreppe@aspyct.org
-   Or via twitter: @aspyct
-   Or drop a ticket on the issue tracker here.
-   Visit [my website](http://www.aspyct.org), aspyct.org

License & Author
----------------

Feel free to use this for commercial works, and I'd be glad to hear from you, or why not see my name in a "thanks" section :)


This code is available under the MIT license.

Hope you like this little utility. Have fun!


