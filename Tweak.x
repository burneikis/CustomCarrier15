#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>

static NSString * nsDomainString = @"com.alexburneikis.customcarrier15";
static NSString * nsNotificationString = @"com.alexburneikis.customcarrier15/preferences.changed";
static BOOL enabled;
static NSString * carrierText;  // Declare carrierText variable

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber * enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;

	// Read value of carrierText preference setting
	carrierText = [[NSUserDefaults standardUserDefaults] objectForKey:@"carrierText" inDomain:nsDomainString];
}

%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

	// Add any personal initializations

}

BOOL isCarrier(NSString *string) {
	if ([string rangeOfString:@":"].location != NSNotFound) {
		return NO;
	}
	if (string.length <= 2) {
		return NO;
	}
	return YES;
}

%hook _UIStatusBarStringView

-(void)setText:(NSString *)text {
	if (isCarrier(text) && enabled) {
		%orig(carrierText);  // Use carrierText variable as the value for carrierText
	} else {
		%orig(text);
	}
}

%end
