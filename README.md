# GooglePlaceApiAutocomplete_DEMO
This is a demo for Google Places Autocomplete API. And mapping with Google map SDK.
##Screenshots
<div style="float:left;">
    <img src="https://raw.githubusercontent.com/ithree1113/GooglePlaceApiAutocomplete_DEMO/master/ScreenShot/shot1.png" width="200">
    <img src="https://raw.githubusercontent.com/ithree1113/GooglePlaceApiAutocomplete_DEMO/master/ScreenShot/shot2.png" width="200">
    <img src="https://raw.githubusercontent.com/ithree1113/GooglePlaceApiAutocomplete_DEMO/master/ScreenShot/shot3.png" width="200">
</div>

##Getting Started
###key
1. You can follow step4 & step5 to get your API key in [here](https://developers.google.com/places/ios-api/start).  
2. Copy the API key and paste it in AppDelegate.m.

```objc
#define GOOGLE_API_KEY @"YOUR_API_KEY"
```
###Installation with CocoaPods
All needed pods are included in this demo, you can test directly. You can refer to [Podfile](https://raw.githubusercontent.com/ithree1113/GooglePlaceApiAutocomplete_DEMO/master/Podfile) to check the installed pods.

##Google Places API

The method below provides an array of [GMSAutocompletePrediction](https://developers.google.com/places/ios-api/reference/interface_g_m_s_autocomplete_prediction) objects when successful.

```objc
[placesClient autocompleteQuery:searchText
                         bounds:nil
                         filter:filter
                       callback:^(NSArray *results, NSError *error) {
                                   if (error != nil) {
                                       NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                       return;
                                   }
                                   searchResult = results;
                               }];

```
Then the method below gets [GMSPlace](https://developers.google.com/places/ios-api/reference/interface_g_m_s_place) object from GMSAutocompletePrediction.placeID selected to use, such as mapping.

```objc
[placesClient lookUpPlaceID:place.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (result != nil) {
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:result.coordinate zoom:16];
            [googleMap animateWithCameraUpdate:cameraUpdate];
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = result.coordinate;
            marker.title = result.name;
            marker.map = googleMap;
        } else {
            NSLog(@"No place details for %@", result.placeID);
        }
    }];
```

##Terms
GooglePlaceApiAutocomplete_DEMO uses the Google Places API and Google Map API,and is bound under [Google's Places API Policies](https://developers.google.com/places/webservice/policies) and [Google Maps/Google Earth APIs Terms of Service](https://developers.google.com/maps/terms).

## License
GooglePlaceApiAutocomplete_DEMO is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/ithree1113/GooglePlaceApiAutocomplete_DEMO/master/LICENSE) file for more info.