-- Tatiana Zihindula : SUPERVISOR ROLE

-- C16339923
-- CAR TEST CENTER CASE STUDY : Mid Term Databases 2 CA

-- YEAR 3 : CAR TEST ASSIGNMENT

-- views do not need to be emptied, but if required, see supervisor.sql

-- setup

select * from dt2283group_n.staff;


-- SETUP , BEFORE DEMO
begin

	-- NOTICE: the case where certain staff could be ill/away/absent etc. is governed by the last time
	-- they signed in the system, this part UPDATEs their sign in date manually to catch up
	declare
		treshold number;
	begin
		select min((TRUNC(SysDate)) - TRUNC(to_date(SlastSignedIn))) into treshold from dt2283group_n.STAFF;
		update dt2283group_n.STAFF
		set SlastSignedIn = SlastSignedIn + treshold ;
		commit;
	end;
	delete from dt2283group_n.car where carregno='EU-001';

	-- Insert the car that will be beleted
	INSERT INTO dt2283group_n.Car VALUES ('EU-001','VW Polo','VW', '16-NOV-2013','mabradley@em.com');
	-- send the letter(s) to this car, past and present
	INSERT INTO  dt2283group_n.LETTER  VALUES ('18-NOV-18:EU-001', '18-NOV-18', 3, 'EU-001', default); -- WILL FAIL THE TEST 3 TIMES
	INSERT INTO  dt2283group_n.LETTER  VALUES ('18-APR-18:EU-001', '18-APR-18', 3, 'EU-001', default);
	INSERT INTO  dt2283group_n.LETTER  VALUES ('01-JAN-18:EU-001', '01-JAN-18', 3, 'EU-001', default);

	-- submit the letter
	update dt2283group_n.LETTER set
	SubmittedOnDate = sysdate
	where CarRegNo IN ('EU-002', 'EU-001', 'US-002', 'IE-000') and SubmittedOnDate is null;
	-- Create two dummy 'previously failed cars'
	delete from dt2283group_n.FinalResults;

	INSERT INTO  dt2283group_n.FinalResults  VALUES ('EU-001', 'jmeyer@staff.ie','fail', '25-APR-18');
	INSERT INTO  dt2283group_n.FinalResults  VALUES ('EU-001', 'jmeyer@staff.ie','fail', '18-JAN-18');

	-- deallocate all currently allocated cars
	delete from DT2283GROUP_N.TESTALLOCATED;
	-- Undo the update made by 3 weeks appointment
	update dt2283group_n.letter set letterdate = '18-NOV-18' where letterID = '18-NOV-18:IE-000';
	-- Done 👻
end;


-- See what mechanic signed in today
select * from IS_AVAILABLE;


-- check what mechanic is specialised in what
select * from dt2283group_n.STAFFSPECIALITY;


-- view Owner's submit the letter, this simulates the owner role.
select * from SUBMITTEDLETTERS;


--  check if any mechanics has been allocated (NONE YET)
select * from dt2283group_n.TestAllocated;

-- allocate mechanics in CENTERS THAT HAVE LETTERS SUBMITTED (SUPERVISOR ROLE)
begin
	for c in (select distinct centerID from SUBMITTEDLETTERS) loop
        DBMS_OUTPUT.PUT_LINE(ALLOCATE_SUBMITTED(c.centerID));
    end loop;
    commit;
exception
    when others then
    rollback;
    raise;
end;


-- view allocated mechanic specialist to each car-test
select * from dt2283group_n.TESTALLOCATED;

-- view cars that completed their tests
select * from FRONT_DOOR;

-- NOTE: to have cars at the FRONT_DOOR mechanics have to have performed their ROLEs
-- My scope only focuses on the SUPERVISOR role, so I will use dummy UPDATEs below to SIMULATE the mechanic role

-- CASE 1: WILL PASS : a pass will have the car simply returned to the owner.
update DT2283GROUP_N.TESTALLOCATED set
TESTSTATUS = 'pass',
TESTCOMMENTS = 'all good'
where LETTERID = '18-NOV-18:EU-002';

-- CASE 2: WILL FAIL ONCE : will not be destroyed, but will have a 3 weeks appointment scheduled for another test.
update DT2283GROUP_N.TESTALLOCATED set
TESTSTATUS = 'fail',
TESTCOMMENTS = 'This car is not worthy to lift Mjölnir and therefore violates article 137 of the road rage.'
where LETTERID = '18-NOV-18:IE-000';


-- CASE 4: WILL FAIL THE TEST THE 3rd TIME and be destroyed
update DT2283GROUP_N.TESTALLOCATED set
TESTSTATUS = 'fail',
TESTCOMMENTS = 'Bad health and dangerous!'
where LETTERID = '18-NOV-18:EU-001';

commit;

-- AFTER MECHANIC SIMULATION : view changes

select * from DT2283GROUP_N.TESTALLOCATED;

-- THE 3 cars (PASS, FAIL ONCE, FAIL 3 TIMES , should now be at the front door
select * from FRONT_DOOR;


-- check the destroyed database BEFORE DESTROYING THE FAIL 3 TIMES CASE

-- Cars are at the front door, no results has been calculated yet.
select * from DT2283GROUP_N.FINALRESULTS;
-- the car that filed once should now have 0 weeks appointment
select 'The letter 18-NOV-18:EU-001 was submitted '|| round((sysdate - submittedondate) ) ||' days away from today.' schedule
from submittedletters where letterID='18-NOV-18:IE-000'; -- follow the 3 weeks rescheduling


-- now update the final database, this will delete the car with 2 fails and schedule a 3 weeks appointment with failed once
declare
supervisor_id DT2283GROUP_N.staff.staffemail%type;
center_name DT2283GROUP_N.Center.CenterName%type;
begin
    for c in (select letterID, centerID from FRONT_DOOR join DT2283GROUP_N.LETTER using(letterID)) loop
		select CenterName into center_name from DT2283GROUP_N.center where centerID=c.centerID;
		select STAFFEMAIL into supervisor_id from (
			select STAFFEMAIL from IS_AVAILABLE
			where srole='supervisor' and centerID=c.centerID
		)ORDER BY dbms_random.value -- pick one supervisor at random
		fetch first row only; -- there might be more than one supervisor in real life?

		if supervisor_id is not null then
			DBMS_OUTPUT.PUT_LINE(SET_FINAL(c.letterID, supervisor_id));
		else
			DBMS_OUTPUT.PUT_LINE('No supervisors today in center: '|| center_name);
		end if;
    end loop;
    commit;
exception
    when others then
    raise;
    rollback;
end;


-- Resolved cars should be gone from allocation table
select * from DT2283GROUP_N.TESTALLOCATED;

-- Nothing should be at the front door or only cars that did not have supervisors to sign them off
select * from FRONT_DOOR;

-- final results should have all the results from all tests weather destroyed or not
select * from DT2283GROUP_N.FINALRESULTS;

-- the car that filed once should now have 3 weeks appointment
select 'The letter 18-NOV-18:EU-001 has been rescheduled ' || ceil((letterdate - sysdate)/7 ) ||' weeks away from today.' schedule
from DT2283GROUP_N.letter where letterID='18-NOV-18:IE-000'; -- follow the 3 weeks rescheduling
