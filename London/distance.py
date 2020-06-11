import pandas as pd
import numpy as np
from geopy.geocoders import Nominatim
from geopy.extra.rate_limiter import RateLimiter
from geopy.distance import vincenty

#add London to the area
df = pd.read_stata(r'C:\Users\liudm\sciebo3\newspaper_data\Stata_data\Elmer_1_corrected.dta')
df['Area'] = df['Area'].astype(str) + ' London' 

#generate coordinates
geolocator = Nominatim(user_agent="s6likise@uni-bonn.de")
geocode = RateLimiter(geolocator.geocode, min_delay_seconds=1)
df['location'] = df['Area'].apply(geocode)
df['point'] = df['location'].apply(lambda loc: tuple(loc.point) if loc else None)

#generate distance from Buckingham Palace
position = np.linspace(0, 1346, num=1347)
df['distance'] = 0
Buck_palace = (51.500841300000005, -0.14298782562962786)
for p in position:
    df['distance'][p] = vincenty(Buck_palace, df['point'][p]).km
    
#save
del df['location']
del df['point']
df.to_stata(r'C:\Users\liudm\sciebo3\newspaper_data\Stata_data\Elmer_1_corrected_dist.dta')