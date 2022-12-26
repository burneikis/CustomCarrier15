#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>

static NSString * nsDomainString = @"com.alexburneikis.customcarrierprefs";
static NSString * nsNotificationString = @"com.alexburneikis.customcarrierprefs/preferences.changed";
static BOOL enabled;
static NSString * carrierText;  // Declare carrierText variable
static NSNumber * cellularLength;  // Declare cellularLength variable

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber * enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;

	// Read value of carrierText preference setting
	carrierText = [[NSUserDefaults standardUserDefaults] objectForKey:@"carrierText" inDomain:nsDomainString];

	// Read value of cellularLength preference setting
	cellularLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"cellularLength" inDomain:nsDomainString];
}

%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

	// Add any personal initializations

}

BOOL isCarrier(NSString *string, NSNumber *length) {
	if ([string rangeOfString:@":"].location != NSNotFound) {
		return NO;
	}
	if (string.length <= 2) {
		return NO;
	}
	if (string.length <= [length integerValue]) {
		if ([string rangeOfString:@"G"].location != NSNotFound) {
			return NO;
		}
	}
	if ([string isEqualToString:@"LTE"]) {
		return NO;
	}
	if ([string rangeOfString:@"%"].location != NSNotFound) {
		return NO;
	}
	if ([string rangeOfString:@"◀︎"].location != NSNotFound) {
		return NO;
	}
	return YES;
}

%hook _UIStatusBarStringView

-(void)setText:(NSString *)text {
	if (isCarrier(text, cellularLength) && enabled) {
		%orig(carrierText); 
	} else {
		%orig(text);
	}
}

%end
