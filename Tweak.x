#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>

static NSString * nsDomainString = @"com.alexburneikis.customcarrierprefs";
static NSString * nsNotificationString = @"com.alexburneikis.customcarrierprefs/preferences.changed";
static BOOL enabled;
static NSString * customText;

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber * enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;

	// Read value of customText preference setting
	customText = [[NSUserDefaults standardUserDefaults] objectForKey:@"customText" inDomain:nsDomainString];
}

%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
}

%hook _UIStatusBarDataCellularEntry

-(void)setString:(id)string {
	if (!enabled) { return %orig; }

	%orig(customText);

}

%end
