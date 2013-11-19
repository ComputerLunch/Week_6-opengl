

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OurAnnotation : MKAnnotationView <MKAnnotation>{
    
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;

@end
