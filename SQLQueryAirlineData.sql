
--/https://www.bts.gov/topics/airlines-and-airports/airline-codes - Codes for respected airlines "carrier"
--/ DB1B Survey Key https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=FKF, https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=FKF

--/Looking at Top 1000 rows for main table to have more accurate understanding of the data set./
SELECT TOP (1000) [ItinID]
      ,[MktID]
      ,[MktCoupons]
      ,[Year]
      ,[Quarter]
      ,[OriginAirportID]
      ,[OriginAirportSeqID]
      ,[OriginCityMarketID]
      ,[Origin]
      ,[OriginCountry]
      ,[OriginStateFips]
      ,[OriginState]
      ,[OriginStateName]
      ,[OriginWac]
      ,[DestAirportID]
      ,[DestAirportSeqID]
      ,[DestCityMarketID]
      ,[Dest]
      ,[DestCountry]
      ,[DestStateFips]
      ,[DestState]
      ,[DestStateName]
      ,[DestWac]
      ,[AirportGroup]
      ,[WacGroup]
      ,[TkCarrierChange]
      ,[TkCarrierGroup]
      ,[OpCarrierChange]
      ,[OpCarrierGroup]
      ,[RPCarrier]
      ,[TkCarrier]
      ,[OpCarrier]
      ,[BulkFare]
      ,[Passengers]
      ,[MktFare]
      ,[MktDistance]
      ,[MktDistanceGroup]
      ,[MktMilesFlown]
      ,[NonStopMiles]
      ,[ItinGeoType]
      ,[MktGeoType]
      ,[Column 41]
  FROM [AirlineData].[dbo].[Airline_Market]

--/Main Table For airline data set
  Select *
  FROM [AirlineData].[dbo].[Airline_Market]
 
--/The Joining table
  SELECT *
  FROM [AirlineData].[dbo].[Airline_Tickets]

--/Looking at NewYork to Hawaii
SELECT Airline_Tickets.ItinFare, Airline_Tickets.OriginStateName, Airline_Market.DestState, Airline_Market.Year, Airline_Market.Quarter, Airline_Market.Origin, Airline_Market.TKCarriergroup, Airline_Market.AirportGroup, Airline_Market.RPCarrier,  Airline_Market.OPCarrierGroup
FROM Airline_Tickets
JOIN Airline_Market 
ON Airline_Market.ItinID = Airline_Tickets.ItinID
WHERE DestState = 'HI'
AND Airline_Tickets.OriginStateName = 'New York'
--GROUP BY OriginStateName
ORDER BY Airline_Tickets.ItinFare asc 

--/Looking at Texas to Hawaii
SELECT Airline_Tickets.ItinFare, Airline_Tickets.OriginStateName, Airline_Market.DestState, Airline_Market.Year, Airline_Market.Quarter, Airline_Market.Origin, Airline_Market.TKCarriergroup, Airline_Market.AirportGroup, Airline_Market.RPCarrier,  Airline_Market.OPCarrierGroup
FROM Airline_Tickets
JOIN Airline_Market 
ON Airline_Market.ItinID = Airline_Tickets.ItinID
WHERE DestState = 'HI'
AND Airline_Tickets.OriginStateName = 'Texas'
--GROUP BY OriginStateName
ORDER BY Airline_Tickets.ItinFare asc 

--/All Itinararies to Hawaii from any state.
SELECT Airline_Tickets.ItinFare, Airline_Tickets.OriginStateName, Airline_Market.DestState, Airline_Market.Year, Airline_Market.Quarter,Airline_Market.Origin
FROM Airline_Tickets
JOIN Airline_Market 
ON Airline_Market.ItinID = Airline_Tickets.ItinID
WHERE DestState = 'HI'

--/Creating table For all flights to Hawaii Originating in any state in the US.
CREATE VIEW [Flights to Hawaii 2021] AS
SELECT Airline_Tickets.ItinFare, Airline_Tickets.OriginStateName, Airline_Market.DestState, Airline_Market.Year, Airline_Market.Quarter, Airline_Market.Origin, Airline_Market.TKCarriergroup, Airline_Market.AirportGroup, Airline_Market.RPCarrier,  Airline_Market.OPCarrierGroup
FROM Airline_Tickets
JOIN Airline_Market 
ON Airline_Market.ItinID = Airline_Tickets.ItinID
WHERE DestState = 'HI'
--ORDER BY Airline_Tickets.ItinFare asc 

--/Average Itinerary price for each state for a trip to Hawaii.
SELECT OriginStateName, AVG(ItinFare) AS 'Average Itinerary Price'
FROM [Flights to Hawaii 2021]
GROUP BY OriginStateName


