-- Tatiana Zihindula : SUPERVISOR ROLE

-- C16339923
-- CAR TEST CENTER CASE STUDY : Mid Term Databases 2 CA

-- YEAR 3 : CAR TEST ASSIGNMENT


-- Methods and tables private to the supervisor role
DROP VIEW IS_AVAILABLE; -- gives all staff that are available today i.e signed in
drop view front_door; -- finished serviced cars


-- IMPORTANT: THIS AVAILABILITY IS MEASURED IN TERM OF THE LAST TIME A SIGNED IN. i.e RECORDED THEIR DATE
-- mechanics have to sign in on that day to update this table
-- NOTE: IF staff's LastSIGNEDIN date is NOT UPDATED in testcase.sql, NO MECHANIC WILL BE AVAILABLE for ANY TEST allocation today
CREATE view IS_AVAILABLE as
select STAFFEMAIL, CENterID , SROLE
	from dt2283group_n.STAFF
    where ((TRUNC(SysDate))=TRUNC(SlastSignedIn));



-- UTILITY: GET A RANDOM STAFF AVAILABLE TODAY WITH A SPECIFIC SPECIALITY FROM A SPECIFIC TESTCENTER
-- My algorithm to assign a staff was to choose any staff at random from available staff today that is specialised in
-- X testtype. This, in my opinion uniformly distribute chances of every staff to use their skills.
-- used to FILTER, REDUCE dataset, when allocating tests to mechanics.

create or replace function GET_MECHANIC_SPECIALIST (
	test_type dt2283group_n.TestType.TestTypeid%type,
	center_id dt2283group_n.center.centerid%type ) return varchar2 as
	mechanic_email varchar2(20);
begin
	select STAFFEMAIL into mechanic_email from (
		select STAFFEMAIL from (
			select STAFFEMAIL from IS_AVAILABLE where centerID=center_id
			intersect
			select STAFFEMAIL from dt2283group_n.STAFFSPECIALITY where TestTypeID = test_type
		)
		ORDER BY dbms_random.value -- SHUFFLE the result to assign almost a different staff for different teststypes
		FETCH FIRST ROW ONLY-- only fetch the very first picked at random (Optimisation)
	);
	return mechanic_email;
exception
	when others then
		rollback;
		raise;
end GET_MECHANIC_SPECIALIST;


-- SUBMIT LETTER: used by the owner to submit the letter
-- I implemented this as part of supervisor role but it is not related in my opinion
-- All supervisor roles assume test cases are allocated, thus the use of custom test cases. (more on this is testcase.sql)
create or replace function SUBMIT_LETTER RETURN number IS
	letter_date     dt2283group_n.letter.letterdate%type := '&enter_letter_date';
	car_reg         dt2283group_n.letter.letterid%type := '&enter_car_reg_no';
	letter_id       dt2283group_n.letter.letterid%type;
	letter_center   dt2283group_n.letter.centerid%type;
begin
	letter_id := trim(upper(letter_date||':'||car_reg));
	select CENTERID into letter_center from dt2283group_n.LETTER where LETTERID=letter_id; -- read the enter value shown on the letter
	INSERT INTO dt2283group_n.SUBMITTEDLETTERS VALUES(letter_id,letter_center, sysdate);
	commit;
	return 0;
EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		DBMS_OUTPUT.PUT_LINE('Letter already submitted.');
        raise;
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Invalid letter.');
        raise;
	WHEN OTHERS THEN
		ROLLBACK;
        raise;
end SUBMIT_LETTER;



-- UTILITY: GET ALL CARS THAT HAVE ALL TEST DONE, used by FRONT_DOOR view : Filtering
CREATE or REPLACE function IS_FINISHED(letter_id dt2283group_n.letter.letterid%type) return number as
initial number;
finished number;
begin
	select count(TestTypeID) into initial from dt2283group_n.TESTTYPE;
	select count(*) into finished from dt2283group_n.TESTALLOCATED where TESTSTATUS is not null and LETTERID=letter_id;
	if initial = finished then
		return 0;
	else
		return 1;
	end if;
end IS_FINISHED;


-- UTILITY: display all cars with completed tests : used when moving to computing final car score
CREATE VIEW FRONT_DOOR AS
select distinct letterID from dt2283group_n.TESTALLOCATED where IS_FINISHED(LETTERID) = 0;



-- UTILITY:  mechanics to all the tests needed for on ONE LETTER SUBMITTED IN THE GIVEN TESTCENTER
-- USED when allocating mechanics in all submitted letters
CREATE or REPLACE function ALLOCATE_MECHANIC_IN_CENTER(
    letter_id dt2283group_n.letter.letterid%type,
    center_id dt2283group_n.CENTER.centerid%type
) return number as
	mec_email dt2283group_n.staff.staffemail%type;
begin
	for t in (select TESTTYPEID from dt2283group_n.TESTTYPE) loop
        begin
            mec_email := GET_MECHANIC_SPECIALIST(t.TestTypeID, center_id); -- get a random mechanic that specialises in this test
            INSERT INTO dt2283group_n.TestAllocated VALUES (letter_id, t.TestTypeid,mec_email, default , DEFAULT);
            commit;
        exception
            when OTHERS then
                RAISE;
        end;
	end loop;
	commit;
	return 0;
exception
	when NO_DATA_FOUND then
		DBMS_OUTPUT.PUT_LINE('Letter '|| letter_id||' already allocated.');
		rollback;
	return 0;
end ALLOCATE_MECHANIC_IN_CENTER;


-- ALLOCATE MECHANICS TO ALL LETTERS SUBMITTED IN A GIVEN CENTER,  DATA MAPPING on dataset
CREATE or REPLACE function ALLOCATE_SUBMITTED(center_id dt2283group_n.CENTER.centerid%type) return number
AS
BEGIN
	-- allocate mechanics to letters that were submitted today
	FOR l in ( select LetterID from (select distinct letterID from dt2283group_n.SUBMITTEDLETTERS
        WHERE centerID = center_id)
	) LOOP
		begin
			DBMS_OUTPUT.PUT_LINE(ALLOCATE_MECHANIC_IN_CENTER(l.letterID, center_id));
		end;
	END LOOP;
	commit;
	return 0;
EXCEPTION
	WHEN OTHERS THEN
	rollback;
		 RAISE;
END ALLOCATE_SUBMITTED;




-- Set the final score on a car that has been allocated

CREATE or REPLACE function SET_FINAL(
letter_id dt2283group_n.letter.letterid%type,
superv_id dt2283group_n.staff.staffemail%type) return varchar2 as

warning number := 0; -- number of warnings a testtype scored
pass number := 0;	-- number of passes a testtype scored
score varchar2(10);	-- final score fail/pass/warning
critical_fail number := 0; -- was it a critical fail?
fail_cause varchar2(512); -- failure reason
fail_count_year number := 0; -- number of time this car failed this year alone
car_reg dt2283group_n.car.carregno%type; -- the car plate number (registration number)
detailed_score varchar2(1024):=''; -- outstanding letter to why the car will be destroyed (if failed critically)
center_id dt2283group_n.center.centerid%type;
begin
	for t in (
                select TestTypeID, TestCriticality, testComments, testStatus
                from dt2283group_n.TESTALLOCATED al
                join dt2283group_n.TestType USING(TestTypeID)
                where letterID=letter_id
	) loop
		IF t.TestCriticality = 'high' and t.testStatus = 'fail' then
			critical_fail := 1; -- fails critically all tests if one high criticality test fails

			fail_cause := t.TestTypeID || ': '||t.testComments; -- append the comment fronm mechanic as the outstanding reason

			EXIT when critical_fail > 0; -- break the loop, we are done here!
		ELSIF t.testStatus = 'warning' then
			warning := warning + 1;
		ELSE
			pass := pass + 1;
		END if;
	end loop;

	-- read the car's registration number on the letter
	select carregno into car_reg from dt2283group_n.LETTER where LETTERID = letter_id;
	-- read the car's center on from the letter
	select CenterID into center_id from dt2283group_n.LETTER where LETTERID = letter_id;
	-- check how many times this car has failed this year
	select count(*) into fail_count_year from (
       select carregno from dt2283group_n.FinalResults where carregno=car_reg
    );

	-- if the car failed critically
	if critical_fail > 0 then
		score := 'fail';
		-- destroy the car if it has now failed 3 times or more by adding it to Destroy table
		if fail_count_year >= 2 then
            begin
            	-- NOTE: this car could as well be deleted from the databases and have all constraints dropped
            	-- The description is not explicit on what 'destroy' means, therefore hard to predict.
            	-- I decided to keep all destroyed cars in a Destroy table for logging purposes?
            	-- This gives more option like, removing all cars in the destroy table after N days? Hmm?
            	-- But maybe the same car cannot be re-registered and therefore unnecessary to keep its data?
            	-- Also data protection..etc? but that's a different story.

                insert into dt2283group_n.DESTROY values(car_reg , sysdate);
                commit;
            exception
                when others then
                DBMS_OUTPUT.PUT_LINE('Car '|| car_reg||' is indestructible? : Destruction failed.');
                rollback;
                raise;
            end;
            -- write outstanding letter to car's owner
			detailed_score := ' this is the 3rd failure, therefore, it is be confiscated and DESTROYED. Failure cause :'|| fail_cause;
			commit;
		else
			-- not the 3rd fail, schedule 3 week appointment in this same center
            begin
                update dt2283group_n.letter set letterdate = (sysdate+ 21) where letterID = letter_id;
                detailed_score := ' Now failed ' || fail_count_year|| 'times.';
                commit;
            exception
                when others then
                rollback;
                raise;
            end;
		end if;
	-- if warning count equals pass count then the score is warning!
	elsif warning >= pass then
		score := 'warning';
	else
		score := 'pass';
	end if;

	-- save the test results
    begin
       insert into dt2283group_n.FINALRESULTS values (car_reg, superv_id, score, default);

       -- mark this letter as resolved by removing the car from TestAllocated

       -- these two updates are in same transaction because it doesn't make sense in real life
       -- to mark the car as resolved if its resolution data cannot be accessed.
       -- If the result cannot be queried, IT DIDN'T HAPPEN.
       -- only if the result is present then delete it from TestAllocation.

       -- Similarly if the car cannot be deleted from TestAllocation then there is something
       -- to resolve about that car, thus, rollback this whole transaction immediately
       delete from dt2283group_n.TESTALLOCATED where LETTERID = letter_id;
       commit;
    exception
        when others then
        DBMS_OUTPUT.PUT_LINE('The results for car '|| car_reg||' could not be stored,thus, car not deallocated.');
        rollback;
        raise;
    end;

	commit; -- Commit everything. We are successfully done here.

	return  'The car :'|| car_reg || ' scored:' || upper(score) || '.'|| detailed_score;
exception
	when others then
	rollback;-- rollback the whole transaction if anything whatsoever goes wrong
	raise;
end SET_FINAL;




commit;
