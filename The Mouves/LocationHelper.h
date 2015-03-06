//
//  LocationHelper.h
//
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationHelper : NSObject<CLLocationManagerDelegate>
+ (instancetype)sharedLocationHelper;
-(void)startTrackingLoocation;
-(void)stopTrackingLocation;

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic,retain) NSString *formatedAddress;
@property (nonatomic) BOOL check;
@end
