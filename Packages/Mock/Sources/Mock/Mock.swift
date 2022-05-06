//
//  Mock.swift
//  
//
//  Created by Jeremy Greenwood on 5/6/22.
//

import Foundation
import Model

public struct Mock {
    /// Returns a static list of Place types
    public static var places: [Place] {
        try! decoder.decode(
            [Place].self,
            from: placesJSON.data(
                using: .utf8)!
        )
    }
}

private extension Mock {
    static var decoder = JSONDecoder()

    static var placesJSON = """
    [{
        "business_status": "OPERATIONAL",
        "formatted_address": "1 Macquarie St, Sydney NSW 2000, Australia",
        "geometry": {
            "location": {
                "lat": -33.8592041,
                "lng": 151.2132635
            },
            "viewport": {
                "northeast": {
                    "lat": -33.85786707010728,
                    "lng": 151.2147093298927
                },
                "southwest": {
                    "lat": -33.86056672989272,
                    "lng": 151.2120096701072
                }
            }
        },
        "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
        "icon_background_color": "#FF9E67",
        "icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet",
        "name": "Aria Restaurant Sydney",
        "opening_hours": {
            "open_now": false
        },
        "place_id": "ChIJdxxU1WeuEmsR11c4fswX-Io",
        "plus_code": {
            "compound_code": "46R7+88 Sydney, New South Wales, Australia",
            "global_code": "4RRH46R7+88"
        },
        "price_level": 4,
        "rating": 4.5,
        "reference": "ChIJdxxU1WeuEmsR11c4fswX-Io",
        "types": ["restaurant", "food", "point_of_interest", "establishment"],
        "user_ratings_total": 1686
    },
    {
        "business_status": "OPERATIONAL",
        "formatted_address": "15 Bligh St, Sydney NSW 2000, Australia",
        "geometry": {
            "location": {
                "lat": -33.8651396,
                "lng": 151.2104533
            },
            "viewport": {
                "northeast": {
                    "lat": -33.86384962010728,
                    "lng": 151.2118993298927
                },
                "southwest": {
                    "lat": -33.86654927989272,
                    "lng": 151.2091996701073
                }
            }
        },
        "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
        "icon_background_color": "#FF9E67",
        "icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet",
        "name": "Restaurant Hubert",
        "opening_hours": {
            "open_now": false
        },
        "place_id": "ChIJF5-RdGquEmsR5rN_H74uSqQ",
        "plus_code": {
            "compound_code": "46M6+W5 Sydney, New South Wales, Australia",
            "global_code": "4RRH46M6+W5"
        },
        "price_level": 3,
        "rating": 4.6,
        "reference": "ChIJF5-RdGquEmsR5rN_H74uSqQ",
        "types": ["restaurant", "food", "point_of_interest", "establishment"],
        "user_ratings_total": 2370
    },
    {
        "business_status": "OPERATIONAL",
        "formatted_address": "529 Kent St, Sydney NSW 2000, Australia",
        "geometry": {
            "location": {
                "lat": -33.8751241,
                "lng": 151.2049722
            },
            "viewport": {
                "northeast": {
                    "lat": -33.87375712010727,
                    "lng": 151.2065098798927
                },
                "southwest": {
                    "lat": -33.87645677989271,
                    "lng": 151.2038102201073
                }
            }
        },
        "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
        "icon_background_color": "#FF9E67",
        "icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet",
        "name": "Tetsuya's Restaurant",
        "opening_hours": {
            "open_now": false
        },
        "place_id": "ChIJxXSgfDyuEmsR3X5VXGjBkFg",
        "plus_code": {
            "compound_code": "46F3+XX Sydney, New South Wales, Australia",
            "global_code": "4RRH46F3+XX"
        },
        "price_level": 4,
        "rating": 4.6,
        "reference": "ChIJxXSgfDyuEmsR3X5VXGjBkFg",
        "types": ["restaurant", "food", "point_of_interest", "establishment"],
        "user_ratings_total": 1133
    },
    {
        "business_status": "OPERATIONAL",
        "formatted_address": "98 Clarence St, Sydney NSW 2000, Australia",
        "geometry": {
            "location": {
                "lat": -33.8679688,
                "lng": 151.2053027
            },
            "viewport": {
                "northeast": {
                    "lat": -33.86664067010727,
                    "lng": 151.2065763298927
                },
                "southwest": {
                    "lat": -33.86934032989272,
                    "lng": 151.2038766701073
                }
            }
        },
        "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
        "icon_background_color": "#FF9E67",
        "icon_mask_base_uri": "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet",
        "name": "Bistro Papillon",
        "opening_hours": {
            "open_now": false
        },
        "place_id": "ChIJywXDWT-uEmsRxyuZ0Inwi04",
        "plus_code": {
            "compound_code": "46J4+R4 Sydney, New South Wales, Australia",
            "global_code": "4RRH46J4+R4"
        },
        "price_level": 3,
        "rating": 4.5,
        "reference": "ChIJywXDWT-uEmsRxyuZ0Inwi04",
        "types": [
            "meal_takeaway",
            "restaurant",
            "food",
            "point_of_interest",
            "establishment"
        ],
        "user_ratings_total": 497
    }]
    """
}
