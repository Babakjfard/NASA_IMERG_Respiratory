Create Space Time Cube From Defined Locations
=====================
Parameters

Input Features     CONUS_counties_2016
Output Space Time Cube     \\vmware-host\Shared Folders\Documents\ArcGIS\Projects\NASA_IMERG_Respiratory\CONUS_respr_mort_2000_2021.nc
Location ID     GEOID
Temporal Aggregation     NO_TEMPORAL_AGGREGATION
Time Field     Date
Time Step Interval     1 Months
Time Step Alignment     END_TIME
Reference Time     
Variables     Total_mortality ZEROS
Summary Fields     
Related Table     CONUS_respr_mortalities
Related Location ID     GEOID
=====================
Messages

Start Time: Thursday, February 15, 2024 6:09:48 AM
json:
[{"element": "table", "data": [[{"data": "Input feature time extent", "prop": {"rowspan": 2}}, "2000-01-01 00:00:00"], [{"data": "to 2021-12-01 00:00:00", "prop": {"text-align": "right"}}], ["", ""], ["Number of time steps", "264"], ["Time step interval", "1 month"], ["Time step alignment", "End"], ["", ""], ["First time step temporal bias", "0.00%"], [{"data": "First time step interval", "prop": {"rowspan": 4}}, "after"], [{"data": "1999-12-01 00:00:00", "prop": {"text-align": "right"}}], [{"data": "to on or before", "prop": {"text-align": "right"}}], [{"data": "2000-01-01 00:00:00", "prop": {"text-align": "right"}}], ["", ""], ["Last time step temporal bias", "0.00%"], [{"data": "Last time step interval", "prop": {"rowspan": 4}}, "after"], [{"data": "2021-11-01 00:00:00", "prop": {"text-align": "right"}}], [{"data": "to on or before", "prop": {"text-align": "right"}}], [{"data": "2021-12-01 00:00:00", "prop": {"text-align": "right"}}], ["", ""], ["Coordinate System", "Albers Conical Equal Area"], ["Cube extent across space", "(coordinates in meters)"], ["Min X", "-2356114.6925"], ["Min Y", "269573.9800"], ["Max X", "2258199.9158"], ["Max Y", "3172568.8310"]], "elementProps": {"striped": "true", "noHeader": true, "title": "Space Time Cube Characteristics", "0": {"align": "left", "pad": "0px", "wrap": true}, "1": {"align": "right", "pad": "0px", "wrap": true}}}]
json:
[{"element": "table", "data": [["Locations", "3108"], ["% of locations with estimated observations", "97.23"], ["- Total number", "3022"], ["Total observations", "820512"], ["% of all observations that were estimated", "37.27"], ["- Total number", "305796"]], "elementProps": {"striped": "true", "noHeader": true, "0": {"align": "left", "pad": "0px", "wrap": true}, "1": {"align": "right", "pad": "0px", "wrap": true}}}]
json:
[{"element": "table", "data": [["Trend direction", "     Increasing"], ["Trend statistic", "6.7406"], ["Trend p-value", "0.0000"]], "elementProps": {"striped": "true", "noHeader": true, "title": "Overall Data Trend - TOTAL_MORTALITY_NONE_ZEROS", "0": {"align": "left", "pad": "0px", "wrap": true}, "1": {"align": "right", "pad": "0px", "wrap": true}}}]
Succeeded at Thursday, February 15, 2024 6:10:59 AM (Elapsed Time: 1 minutes 11 seconds)



