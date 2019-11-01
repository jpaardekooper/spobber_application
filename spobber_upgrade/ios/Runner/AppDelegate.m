#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  // Provide the GoogleMaps API key.
  NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"AIzaSyB-lQhSEggPBYQlqxxtie9otYVzU53X6is"];
  if ([mapsApiKey length] == 0) {
    mapsApiKey = @"AIzaSyB-lQhSEggPBYQlqxxtie9otYVzU53X6is";
  }
  [GMSServices provideAPIKey:mapsApiKey];

  // Register Flutter plugins.
  [GeneratedPluginRegistrant registerWithRegistry:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
