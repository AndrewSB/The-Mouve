//
//  LocationHelper.m
//  
//

#import "LocationHelper.h"

@implementation LocationHelper
@synthesize locationManager,currentLocation;
@synthesize check,formatedAddress;

+ (instancetype)sharedLocationHelper{
    static LocationHelper *_sharedpushHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedpushHelper = [[LocationHelper alloc] init];
        
    });
    return _sharedpushHelper;
}
-(id) init{
    if ((self=[super init])) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
       // self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // fine
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    return self;	
}

-(void)startTrackingLoocation{
    if(self.locationManager){
        [self.locationManager startUpdatingLocation];
    }
}
-(void)stopTrackingLocation{
     if(self.locationManager){
         [self.locationManager stopUpdatingLocation];
     }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    self.currentLocation = newLocation;
    
    NSLog(@"My Location:%f,%f",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude);
       
    [self getAddress];
}

- (double )calculateDistanceInMetersBetweenCoord:(CLLocationCoordinate2D)coord1 coord:(CLLocationCoordinate2D)coord2 {
    
    CLLocation *loc1 = [[CLLocation alloc]initWithLatitude:coord1.latitude longitude:coord1.longitude];
    CLLocation *loc2 = [[CLLocation alloc]initWithLatitude:coord2.latitude longitude:coord2.longitude];
    CLLocationDistance dist = [loc1 distanceFromLocation:loc2];
    
    return dist;
}

-(void)getAddress{
    
    __block NSString *address=@"";
    
    @try {
      
    __block NSString *place_name=@"";
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:self.currentLocation.coordinate.latitude
                                                        longitude:self.currentLocation.coordinate.longitude];
    
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error) {
                                                    
                           return;
                       }
                       
                       if (placemarks && placemarks.count > 0)
                       {
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =
                           placemark.addressDictionary;
                           
                           place_name=[placemark name];
                           
                           NSArray *AddressArray=(NSArray *)[addressDictionary objectForKey:@"FormattedAddressLines"];
                           
                           
                           for (int i=0;i<AddressArray.count; i++) {
                               if(AddressArray.count==1 || (AddressArray.count-1)==i){
                                   address=[address stringByAppendingString:[NSString stringWithFormat:@"%@",[AddressArray objectAtIndex:i]]];
                               }else{
                                   address=[address stringByAppendingString:[NSString stringWithFormat:@"%@,",[AddressArray objectAtIndex:i]]];
                               }
                           }
                           
                       }
                       self.formatedAddress=address;
                       NSLog(@"address:%@",address);
                       
                       [[NSNotificationCenter defaultCenter]
                        postNotificationName:@"LocationUpdateNotification"
                        object:address];
                   }];
    }
    @catch (NSException *exception) {
        
    }
    
}

@end
