1.	List all the people in the passenger table, including their name, itinerary number, fare, and confirmation number. Order by name and fare.

SELECT pas_name,pas_itinerary_no,pas_fare,pas_confirm_no FROM passenger
ORDER BY pas_name,pas_fare

2.	Using an “OR” operator, list pilot name, state, zip code, and flight pay for pilots who make more than $2,500 per flight and live in either the state TX or AZ. Order by pay in descending order.

SELECT pil_pilotname,pil_state,pil_city,pil_zip,pil_flight_pay FROM pilots
WHERE pil_flight_pay > 2500 AND (pil_state = 'TX' OR pil_state = 'AZ')
ORDER BY pil_flight_pay DESC

3. Using an “IN”, list pilot names, zip and flight pay for pilots who make more than $2,500 per flight and live in either the state TX or AZ. Order by pay in descending order.

SELECT Pil_Pilotname, pil_state, pil_city, pil_zip, pil_flight_pay FROM pilots 
WHERE Pil_flight_pay > 2500 AND pil_state IN  ('TX','AZ')
ORDER BY Pil_flight_pay DESC

4. Using a SET OPERATOR, list pilot names, zip and flight pay for pilots who make more than $2,500 per flight and live in either the state TX or AZ. Order by pay in descending order.

SELECT Pil_Pilotname, pil_state, pil_city, pil_zip, pil_flight_pay FROM pilots WHERE Pil_flight_pay > 2500
INTERSECT
SELECT Pil_Pilotname, pil_state, pil_city, pil_zip, pil_flight_pay FROM pilots WHERE pil_state IN  ('TX','AZ')
ORDER BY Pil_flight_pay DESC

5.	Using an “AND” and an “OR”, list all information (Equipment Number, Equipment Type, Seat Capacity, Fuel Capacity, and Miles per Gallon) on aircraft that have a seat capacity greater than 300, or aircraft that have a miles per gallon greater than 3.5 miles per gallon and fuel capacity less than 2500. Order by EQ_EQUIP_No.

SELECT * FROM equip_type 
WHERE eq_seat_capacity > 300 OR 
(EQ_Miles_Per_Gal > 3.5 AND EQ_Fuel_Capacity < 2500)
ORDER BY Eq_Equip_No

6.	Using a SET OPERATION, list all information (Equipment Number, Equipment Type, Seat Capacity, Fuel Capacity, and Miles per Gallon) on aircraft that have a seat capacity greater than 300, or aircraft that have a miles per gallon greater than 3.5 miles per gallon and fuel capacity less than 2500. Order by EQ_EQUIP_No.

SELECT * FROM equip_type WHERE eq_seat_capacity > 300
UNION
SELECT * FROM equip_type WHERE EQ_Miles_Per_Gal > 3.5 AND EQ_Fuel_Capacity < 2500

7. Using PATTERN MATCHING on the AIR_LOCATION attribute, select all information for airports in TX.

SELECT * FROM airport 
WHERE Air_location LIKE '%TX'

8.	Using an aggregate function and HAVING, produce a unique list of pilot Ids as Pilot ID of pilots who piloted more than 20 departures.  Order by pilot id ascending.

SELECT Dep_pilot_id AS Pilot_Id, count(Dep_pilot_id) AS Flights FROM Departures
GROUP BY Dep_pilot_id HAVING count(Dep_pilot_id) > 20
ORDER BY Pilot_Id ASC

9.	List all flights showing flight number, flight fare, flight distance, and the miles flown per dollar (distance/fare) as “Miles Flown Per Dollar” that have miles per dollar greater than $5.50, and sort by miles flown per dollar descending.

SELECT FL_Flight_No AS Flight, Fl_fare AS Fare, Fl_Distance AS Distance, ROUND(Fl_Distance / Fl_fare,2) AS Miles_Flown_Per_Dollar  FROM flight
WHERE ROUND(Fl_Distance / Fl_fare,2) > 5.50 
GROUP BY FL_flight_No, Fl_fare, Fl_Distance
ORDER BY Miles_Flown_Per_Dollar DESC

10. Display airport location and number of departing flights as "Number of departing Flights". 

SELECT Air_location, count(fl_orig) AS Number_of_departing_Flights FROM flight JOIN airport ON flight.fl_orig = airport.air_code
GROUP BY air_location

11.	 List the maximum pay, minimum pay and average flight pay by state for pilots.  Make sure to name the attributes as shown in the example output.

SELECT pil_state AS "State", MAX(pil_flight_pay) AS "Max Pay", MIN(pil_flight_pay) AS "Min Pay", AVG(pil_flight_pay) AS "Avg Pay"  FROM pilots
GROUP BY pil_state

12. Display pilot name and departure date of his first flight. Order by pilot name. 

SELECT * FROM pilots
SELECT * FROM Departures

SELECT Pil_pilotname, MIN(dep_dep_date) AS "First Departure" FROM pilots JOIN departures ON pilots.pil_pilot_id = departures.dep_pilot_id
GROUP BY pil_pilotname
ORDER BY pil_pilotname

13.	For each unique equipment type, List the equipment types and maximum miles that can be flown as "Maximum Distance Flown".  Order by maximum distance descending.

SELECT DISTINCT(Eq_equip_type), (Eq_fuel_capacity * Eq_miles_per_gal) AS "Maximum Distance Flown" FROM equip_type
ORDER BY "Maximum Distance Flown" DESC

14.	List the number of flights originating from each airport as NUMBER_OF_FLIGHTS.

SELECT Fl_orig, COUNT(FL_ORIG) AS NUMBER_OF_FLIGHTS FROM flight
GROUP BY fl_orig


15.	List the equipment type and max distance possible on a full tank of fuel for each plane with a maximum distance greater than 8600. Order by maximum distance, from lowest to highest.

SELECT DISTINCT(Eq_equip_type), (Eq_fuel_capacity * Eq_miles_per_gal) AS "Maximum Distance Flown" FROM equip_type
WHERE (Eq_fuel_capacity * Eq_miles_per_gal) > 8600
ORDER BY "Maximum Distance Flown" ASC
