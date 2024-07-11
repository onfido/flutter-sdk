#import "PluginMetadata.h"

@implementation PluginMetadata

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pluginPlatform = @"flutter";
        _pluginVersion = @"6.2.0";
    }
    return self;
}

@end
