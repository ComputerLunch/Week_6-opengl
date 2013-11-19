

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface ViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapKit;
- (IBAction)goHome:(id)sender;
- (IBAction)goWork:(id)sender;
- (IBAction)goFamily:(id)sender;

@end
