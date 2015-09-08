# DaiMethodHelper

A Tool for scan duplicate methods, verify method implementation, or force invoke the method!

DaidoujiChen

daidoujichen@gmail.com

## Special Thanks
[ryanolsonk](https://github.com/ryanolsonk)

[OptimusKe](https://github.com/OptimusKe)

[MiaShopgal](https://github.com/MiaShopgal)

# Overview
* Scan single class for duplicate methods in categories.
* Like scan single class, we also can scan all of them!
* Verify a method in a class(metaclass). Lookup the current implementation.
* Force to invoke a method. Can not be dodge, swizzling penetration.

# Usage

## Scan
If we want to check if there are any duplicate methods in `NSString`. Using `[DaiMethodHelper scanClass:]`

`````
[DaiMethodHelper scanClass:[NSString class]];

output:
===== Duplicate in NSString =====
-iLoveDaidouji (0x10db6f5eb) in NSString(Daidouji3) from DaiMethodHelper
-iLoveDaidouji (0x10db6ea70) in NSString(Daidouji2) from DaiMethodHelper
-iLoveDaidouji (0x10db6ea50) in NSString(Daidouji1) from DaiMethodHelper
===== Duplicate in NSString =====
-_initWithUTF8String:maxLength: (0x10e7f9316) in NSString(UISafeInstantiators) from UIKit
-_initWithUTF8String:maxLength: (0x111055a1f) in NSString(BaseBoard) from BaseBoard

`````

We found there are three methods named `iLoveDaidouji` in categories `Daidouji1`, `Daidouji2` and `Daidouji3`. 

In the runtime, which one will be invoked?

## Verify
For this concern, `DaiMethodHelper` provide a method to verify. This method named `[DaiMethodHelper verifyClass:selector:]`

`````
[DaiMethodHelper verifyClass:[NSString class] selector:@selector(iLoveDaidouji)];

output:
* -iLoveDaidouji (0x1022225eb) in NSString(Daidouji3) from DaiMethodHelper
  -iLoveDaidouji (0x102221a70) in NSString(Daidouji2) from DaiMethodHelper
  -iLoveDaidouji (0x102221a50) in NSString(Daidouji1) from DaiMethodHelper
`````

As the output, runtime choose the method `iLoveDaidouji` in category `Daidouji3`.

Check it out!

`````
NSString *string = [NSString new];
NSLog(@"%@", [string iLoveDaidouji]);

output:
2015-09-10 15:53:47.727 DaiMethodHelper[9259:212520] iLoveDaidouji3
`````

Yes, it run on category `Daidouji3` correctly. And then, is it possible to run the method in category `Daidouji1`?

## Force
In this case, by default, runtime never choose the method in category `Daidouji1`. We need to use a little trick to done it.

`````
NSString *string = [NSString new];
NSLog(@"%@", [DaiMethodHelper perform:string selector:@selector(iLoveDaidouji) category:@"Daidouji1"]);

output:
found -iLoveDaidouji (0x109589a50) in NSString(Daidouji1) from DaiMethodHelper
2015-09-10 16:03:24.666 DaiMethodHelper[9391:219463] iLoveDaidouji1
`````

The result show, we found a method `-iLoveDaidouji` in category `Daidouji1`. And perform it.

## Swizzling?
Finally we made a simple method swizzling in `MainViewController`. like

> \- (NSString *)swi2_iLoveDaidouji:(NSString *)input {
> 
> NSLog(@"SwizzlingDaidoujiCategory2");
> 
> > \- (NSString *)swi1_iLoveDaidouji:(NSString *)input {
> > 
> > NSLog(@"SwizzlingDaidoujiCategory1");
> > 
> > > \- (NSString *)iLoveDaidouji:(NSString *)input {
> > > 
> > > NSLog(@"OriginDaidouji");
> > > 
> > > return [NSString stringWithFormat:@"iLoveDaidouji+%@", input];
> > > 
> > > }
> > 
> > }
>
> }

`````
NSLog(@"%@", [self iLoveDaidouji:@"very much"]);

output:
2015-09-10 16:10:35.816 DaiMethodHelper[9510:224080] SwizzlingDaidoujiCategory2
2015-09-10 16:10:35.817 DaiMethodHelper[9510:224080] SwizzlingDaidoujiCategory1
2015-09-10 16:10:35.817 DaiMethodHelper[9510:224080] OriginDaidouji
2015-09-10 16:10:35.817 DaiMethodHelper[9510:224080] iLoveDaidouji+very much
`````

The interesting thing is we can also use `[DaiMethodHelper perform:selector:category:]` pass through all whe swizzling.

`````
NSLog(@"%@", [DaiMethodHelper perform:self selector:@selector(iLoveDaidouji:) category:nil, @"very much"]);

output:
swizzling by -swi2_iLoveDaidouji: (0x10992d130) in MainViewController(DaidoujiCategory2) from DaiMethodHelper
 swizzling by -swi1_iLoveDaidouji: (0x10992adb0) in MainViewController(DaidoujiCategory1) from DaiMethodHelper
  found -iLoveDaidouji: (0x10992ce40) in MainViewController from DaiMethodHelper
2015-09-10 16:19:03.590 DaiMethodHelper[9617:228273] OriginDaidouji
2015-09-10 16:19:03.591 DaiMethodHelper[9617:228273] iLoveDaidouji+very much
`````

The method only run the original code. Ignore all the swizzle. Fun!

# Warning
I am not sure apple allow the method `invokeUsingIMP:` in `NSInvocation` or not. 

