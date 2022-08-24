--/ Data sources from http://insideairbnb.com/get-the-data/

--/Data Preperation of listings.xlsx

--/Neighbourhood cleaning:

--/Kappa City updated 35 fields consistent format Kappa City, Hawaii, United States
--/Kailua Kona updated 1185 fields to consistent format Kailua Kona, Hawaii, United States
--/Honolulu updated 3205 fields to consistent format Honolulu, Hawaii, United States
--/Kamuela updated 50 fields to consistent format  Kamuela, Hawaii, United States
--/Kapolei updated 204 fields to consistent format  Kapolei, Hawaii, United States
--/Keaau updated 168 fields to consistent format  Keaau, Hawaii, United States
--/Kihei updated 1535 fields to consistent format  Kihei, Hawaii, United States
--/Koloa updated 545 fields to consistent format Koloa, Hawaii, United States
--/Lahaina updated 1974 fields to consistent format Lahaina, Hawaii, United States
--/Lihue updated 94 fields to consistent format Lihue, Hawaii, United States
--/Maunaloa updated 94 fields to consistent format Maunaloa, Hawaii, United States
--/Mountain View updated 54 fields to consistent format Mountain, Hawaii, United States
--/Ocean View updated 29 fields to consistent format Ocean View, Hawaii, United States
--/Pahoa updated 321 fields to consistent format Pahoa, Hawaii, United States
--/Poipu Koloa updated 10 fields to consistent format Poipu Koloa, Hawaii, United States
--/Princeville  updated 592 fields to consistent format Princeville, Hawaii, United States
--/Volcano updated 178 fields to consistent format Volcano, Hawaii, United States
--/Waikoloa updated 178 fields to consistent format Waikoloa Village, Hawaii, United States
--/Waikoloa Beach updated 44 fields to consistent format Waikoloa Beach, Hawaii, United States
--/Wailea updated 44 fields to consistent format Wailea, Hawaii, United States
--/Waimea updated 263 fields to consistent format Waimea, Hawaii, United States 
--/Wailuku updated 170 fields to consistent format Wailuku, Hawaii, United States

 --/Check of Excel Data Cleaning Final view checks for issues

SELECT TOP(100)*
FROM AirBnB.dbo.listings

SELECT 
DISTINCT(bathrooms_text) 
from final_listing

SELECT 
DISTINCT(neighbourhood) 
from final_listing

SELECT *
FROM [AirBnB].[dbo].[calendar]

Drop VIEW final_listing

--/ Exclusion of any unwanted data from the dbo.listings table. 


CREATE VIEW new_listing AS
SELECT
id,
ISNULL(neighbourhood,'Unavailable') AS neighbourhood, 
neighbourhood_cleansed, 
neighbourhood_group_cleansed, 
latitude,
longitude, 
ISNULL(bedrooms,'Studio') AS bedrooms,
ISNULL(beds,'Unavailable') AS beds,
ISNULL(bathrooms_text,'Unavailable') AS bathrooms_text,
accommodates, 
property_type, 
room_type, 
review_scores_rating, 
review_scores_accuracy,  
review_scores_cleanliness, 
review_scores_checkin, 
review_scores_communication, 
review_scores_location, 
review_scores_value,
number_of_reviews
FROM [AirBnB].[dbo].[listings] 


--/Join create a my file data file. Join of view new_listings and calendar.

CREATE VIEW final_listing AS
SELECT TOP(10) *
FROM new_listing
OUTER JOIN [AirBnB].[dbo].[calendar] 
ON	new_listing.id=calendar.listing_id

--/Final view checks for issues

SELECT *
FROM final_listing

SELECT 
DISTINCT(bathrooms_text) 
from final_listing

SELECT 
DISTINCT(neighbourhood) 
from final_listing

SELECT 
DISTINCT(id),
review_scores_cleanliness
FROM final_listing
WHERE number_of_reviews = '0'


--/ Average of all seven scores to get an overall rating.

SELECT
id,
neighbourhood_cleansed,
review_scores_rating, 
review_scores_accuracy,  
review_scores_cleanliness, 
review_scores_checkin, 
review_scores_communication, 
review_scores_location, 
review_scores_value,
ROUND(SUM(review_scores_rating + review_scores_accuracy +  review_scores_cleanliness + review_scores_checkin + review_scores_communication + review_scores_location + review_scores_value)/7,2) AS average_score
FROM [AirBnB].[dbo].[listings]
GROUP BY id, review_scores_rating, review_scores_accuracy,  review_scores_cleanliness, review_scores_checkin, review_scores_communication, review_scores_location, neighbourhood_cleansed, review_scores_value
ORDER BY id



 --/ Export issue with above. Copied from results pane and pasted in excel. Checked row count via below quer


SELECT
COUNT(id)
FROM [AirBnB].[dbo].[listings]




