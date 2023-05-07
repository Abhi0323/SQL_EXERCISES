#Display the age and name for the pilot who was the oldest when HIRED.
SELECT pil_pilotname, TRUNC(MONTHS_BETWEEN(pil_hiredate, pil_brthdate) / 12, 2) AS "Age" FROM Pilots
WHERE TRUNC(MONTHS_BETWEEN(pil_hiredate, pil_brthdate) / 12, 2) = (SELECT MAX(TRUNC(MONTHS_BETWEEN(pil_hiredate, pil_brthdate) / 12, 2)) FROM pilots)

#Using a SET OPERATOR, display the pilots and the number of miles flown as "Miles Flown", include pilots who have not yet flown (for those pilots, display “0” for miles flown”). 
SELECT pil_pilotname, SUM(fl_distance) AS "Miles Flown" FROM pilots, departures, flight, ticket 
WHERE pil_pilot_id = dep_pilot_id AND tic_flight_no = dep_flight_no AND dep_flight_no = fl_flight_no AND dep_dep_date = tic_flight_date
GROUP BY pil_pilotname
UNION
SELECT pil_pilotname, TO_NUMBER('0') AS "Miles FLown" FROM pilots WHERE pil_pilotname NOT IN (SELECT pilots.pil_pilotname FROM pilots, departures, flight, ticket
WHERE pil_pilot_id = dep_pilot_id AND tic_flight_no = dep_flight_no AND dep_flight_no = fl_flight_no AND dep_dep_date = tic_flight_date
GROUP BY pil_pilotname)

#Parse Pilot Names into First Name / Middle Initial, and Last Name.
SELECT SUBSTR(pil_pilotname, 1, (INSTR(pil_pilotname,',')-1)) AS "Last Name", SUBSTR(pil_pilotname,(INSTR(pil_pilotname,',')+2)) AS "First Name" FROM pilots

#List the pilots that are paid above the average for their state and the state average pay.
SELECT p.pil_pilotname, p.pil_state, p.pil_flight_pay AS "FLight Pay", v.av AS "Average State Pay" FROM pilots p
JOIN (SELECT pil_state, AVG(pil_flight_pay) av  FROM pilots
GROUP BY pil_state) v ON v.pil_state = p.pil_state
WHERE p.pil_flight_pay < v.av

#Display the name of the pilot, pay and age of the pilots under the age of 55 (Hint, you must calculate age using pil_birthdate and sysdate).
SELECT pil_pilotname, pil_flight_pay, TRUNC( MONTHS_BETWEEN(SYSDATE,pil_brthdate)/12,2) AS "Age" FROM pilots
WHERE TRUNC( MONTHS_BETWEEN(SYSDATE,pil_brthdate)/12,2) < 55

#Using a SUB QUERY, display the flight number, originating airport, destination airport, departure time as "Departure Time", and arrival time as "Arrival Time" for flights not departing on May 17, 2017. Note, you will need to use the to_char character mask on the date attributes: to_char(fl_dest_time, 'hh24:mi')
SELECT fl_flight_no, fl_orig, fl_dest,TO_CHAR(fl_orig_time, 'hh24:mi') AS "Departure Time", TO_CHAR(fl_dest_time, 'hh24:mi') AS "Arrival Time" FROM flight
WHERE fl_flight_no NOT IN (SELECT dep_flight_no FROM departures WHERE dep_dep_date = '17-MAY-17')
ORDER BY fl_flight_no

#Using a SET OPERATION, display the flight number, originating airport, destination airport, departure time as "Departure Time", and arrival time as "Arrival Time" for flights not departing on May 17, 2017.
SELECT fl_flight_no, fl_orig, fl_dest,TO_CHAR(fl_orig_time, 'hh24:mi') AS "Departure Time", TO_CHAR(fl_dest_time, 'hh24:mi') AS "Arrival Time" FROM flight
MINUS 
SELECT fl_flight_no, fl_orig, fl_dest,TO_CHAR(fl_orig_time, 'hh24:mi') AS "Departure Time", TO_CHAR(fl_dest_time, 'hh24:mi') AS "Arrival Time" FROM flight
WHERE fl_flight_no IN (SELECT dep_flight_no FROM departures WHERE dep_dep_date = '17-MAY-17')

#Using a SUB QUERY, list pilot names for pilots who have no scheduled departures in May 2017. 
SELECT pil_pilotname FROM pilots
WHERE pil_pilot_id NOT IN (SELECT dep_pilot_id FROM departures WHERE dep_dep_date LIKE '%MAY-17')
ORDER BY pil_pilotname

#Using a SET OPERATION, list pilot names for pilots who have no scheduled departures in May 2017.
SELECT pil_pilotname FROM pilots
MINUS
SELECT pil_pilotname FROM pilots, departures
WHERE pil_pilot_id = dep_pilot_id AND departures.dep_dep_date LIKE '%MAY-17'
ORDER BY pil_pilotname

#Find the number of passengers that have the same last name. Display the number of passengers with each last name, ordered by number of passengers per last name in descending order.
SELECT SUBSTR(Pas_name, INSTR(Pas_name, ' ')+1) AS "Last Name", COUNT(SUBSTR(Pas_name, INSTR(Pas_name, ' ')+1)) AS "Passengers" FROM passenger
GROUP BY SUBSTR(Pas_name, INSTR(Pas_name, ' ')+1) 
ORDER BY COUNT(SUBSTR(Pas_name, INSTR(Pas_name, ' ')+1)) DESC