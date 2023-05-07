#Using an “OR” statement and a “Cartesian product / WHERE” join, display flight number, origination and destination for flights that originate from an airport that does not have a hub airline or flights that originate from an airport that is a hub for American Airlines. Order by FL_FLIGHT_NO.
SELECT fl_flight_no,fl_orig, fl_dest, airport.air_hub_airline  FROM flight JOIN airport ON flight.fl_orig = airport.air_code
WHERE air_hub_airline IS NULL OR air_hub_airline = 'American'
ORDER BY fl_flight_no;

#Using an SET OPERATOR statement and a “JOIN ON” join, display flight number, origination and departure for flights that originate from an airport that does not have a hub airline or flights that originate from an airport that is a hub for American Airlines. Order by FL_FLIGHT_NO.
SELECT fl_flight_no,fl_orig, fl_dest, airport.air_hub_airline  FROM flight JOIN airport ON flight.fl_orig = airport.air_code
WHERE air_hub_airline IS NULL 
UNION
SELECT fl_flight_no,fl_orig, fl_dest, airport.air_hub_airline  FROM flight JOIN airport ON flight.fl_orig = airport.air_code
WHERE air_hub_airline = 'American' 
ORDER BY fl_flight_no;

#Display the flight number, departure date and equipment type for all equipment that is manufactured by Concorde. Order by departure date and flight number.
SELECT dep_flight_no, dep_dep_date, equip_type.eq_equip_type FROM departures JOIN equip_type ON departures.dep_equip_no = equip_type.eq_equip_no
WHERE eq_equip_type = 'CONCORDE'
ORDER BY dep_dep_date, dep_flight_no;

#Using a SET OPERATOR, display the IDs and names of pilots who are not currently scheduled for a departure. 
SELECT PIL_PILOT_ID, PIL_PILOTNAME FROM PILOTS WHERE PIL_PILOT_ID IN (
SELECT DISTINCT PIL_PILOT_ID FROM PILOTS
MINUS
(SELECT DISTINCT DEP_PILOT_ID FROM DEPARTURES))

#Using a SUB QUERY, display the IDs and names of pilots who are not currently scheduled for a departure. 
SELECT PIL_PILOT_ID, PIL_PILOTNAME FROM pilots 
WHERE pil_pilot_id NOT IN (SELECT DISTINCT DEP_PILOT_ID FROM DEPARTURES)

#Using “IS NULL” and an OUTER JOIN, display the IDs and names of pilots who are not currently scheduled for a departure. 
SELECT PIL_PILOT_ID, PIL_PILOTNAME  FROM PILOTS LEFT OUTER JOIN DEPARTURES ON pilots.pil_pilot_id = departures.dep_pilot_id
WHERE dep_dep_date IS NULL

#Display passenger name and seat number, as "Seat Number", for flight 101, departing on July 15, 2017
SELECT pas_name, tic_seat as "Seat Number" FROM passenger JOIN ticket ON passenger.pas_itinerary_no = ticket.tic_itinerary_no
WHERE ticket.tic_flight_no = 101 AND ticket.tic_flight_date = '15-JUL-17'
ORDER BY pas_name

#List flight number, departure date and number of passengers as "Number of Passengers" for departures that have more than 5 passengers. 
SELECT fl_flight_no AS "Flight Number", dep_dep_date "Date", COUNT(tic_flight_no) AS "Number of Passengers" 
FROM flight 
JOIN departures ON flight.fl_flight_no = departures.dep_flight_no
JOIN ticket ON flight.fl_flight_no = ticket.tic_flight_no
GROUP BY fl_flight_no, dep_dep_date
HAVING COUNT(tic_flight_no) > 5

#Select flight number, origination and destination for all reservations booked by Andy Anderson, Order results by flight number.
SELECT fl_flight_no, fl_orig, fl_dest 
FROM flight 
JOIN reservation ON flight.fl_flight_no = reservation.res_flight_no
WHERE res_name = 'Andy Anderson'
ORDER BY fl_flight_no

#Display departing airport code as "Departs From", arriving airport code as "Arrives at", and minimum fair as "Minimum Fair", for flights that have minimum fare for flights between these two airports.
SELECT A1.air_Location AS "Departs From", A2.air_Location AS "Arrives at" , fare AS "Minimum Fare"
FROM (SELECT fl_orig, fl_dest , MIN(fl_fare) as fare FROM Flight GROUP BY fl_orig,
fl_dest) res, airport A1, airport A2
WHERE A1.air_code = res.fl_orig AND A2.air_code = res.fl_dest