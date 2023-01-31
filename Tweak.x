#import <UIKit/UIKit.h>

%hook _UIStatusBarDataCellularEntry

-(void)setString:(id)string {
	NSDictionary *defaults = [[NSUserDefaults standardUserDefaults]
		persistentDomainForName:@"com.alexburneikis.customcarrierprefs"];
	BOOL enabled = [defaults[@"enabled"] boolValue];
	NSString *customText = defaults[@"customText"];

	if (enabled) {
		%orig(customText);
	}
	else {
		%orig;
	}
}

%end
